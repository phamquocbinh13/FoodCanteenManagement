import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';
import {
  conflict,
  notFound,
  notImplemented,
  unauthorized,
  unprocessable,
} from '../common/errors/api-exception';
import {
  generateOpaqueToken,
  sha256Hex,
} from '../common/crypto/token-hash';
import { toNumber } from '../common/utils/big-int';
import { PrismaService } from '../prisma/prisma.service';
import {
  AppendTimelineDto,
  CreateSessionDto,
  UpdateSessionDto,
} from './dto/sessions.dto';
import {
  SessionSnapshot,
  mapSessionSnapshot,
} from './session-snapshot.mapper';

@Injectable()
export class SessionsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(
    restaurantId: string,
    openedByUserId: string,
    dto: CreateSessionDto,
  ): Promise<{ snapshot: SessionSnapshot; sessionToken: string }> {
    const table = await this.prisma.restaurantTable.findFirst({
      where: { id: dto.tableId, restaurantId },
    });
    if (!table) {
      throw notFound('TABLE_NOT_FOUND', 'Table not found');
    }
    if (!table.isActive) {
      throw unprocessable('TABLE_INACTIVE', 'Table is inactive');
    }
    if (table.status === 'reserved') {
      throw unprocessable('TABLE_RESERVED', 'Table is reserved');
    }

    const existing = await this.prisma.dine_in_session.findFirst({
      where: {
        restaurant_id: restaurantId,
        table_id: dto.tableId,
        active_table_guard: dto.tableId,
      },
    });
    if (existing) {
      throw conflict('ACTIVE_SESSION_EXISTS', 'Table already has an active session');
    }

    const settings = await this.prisma.restaurantSettings.findUnique({
      where: { restaurantId },
    });
    const ttlMinutes = settings?.sessionTokenTtlMinutes ?? 480;
    const now = new Date();

    let sessionSequence = dto.sessionSequence;
    if (sessionSequence == null) {
      const dateKey = formatDateKey(now);
      sessionSequence = await this.allocateDailySequence(restaurantId, dateKey);
    }

    const displayNumber =
      dto.displayNumber?.trim() ||
      `S-${String(sessionSequence).padStart(4, '0')}`;

    const sessionToken = dto.sessionToken?.trim() || generateOpaqueToken(32);
    const tokenExpiresAt = dto.tokenExpiresAt
      ? new Date(dto.tokenExpiresAt)
      : new Date(now.getTime() + ttlMinutes * 60_000);

    const sessionId = uuidv4();
    const tokenId = uuidv4();
    const tokenHash = sha256Hex(sessionToken);

    try {
      const session = await this.prisma.$transaction(async (tx) => {
        const stillActive = await tx.dine_in_session.findFirst({
          where: {
            restaurant_id: restaurantId,
            active_table_guard: dto.tableId,
          },
        });
        if (stillActive) {
          throw conflict(
            'ACTIVE_SESSION_EXISTS',
            'Table already has an active session',
          );
        }

        await tx.restaurantTable.update({
          where: { id: dto.tableId },
          data: { status: 'occupied', updatedAt: now },
        });

        const created = await tx.dine_in_session.create({
          data: {
            id: sessionId,
            restaurant_id: restaurantId,
            table_id: dto.tableId,
            session_number: BigInt(sessionSequence!),
            display_number: displayNumber,
            status: 'open',
            opened_via: dto.openedVia,
            opened_by_user_id: openedByUserId,
            payment_soft_lock: false,
            current_batch_number: 0,
            payment_status: 'unpaid',
            payment_subtotal_minor: BigInt(0),
            payment_discount_minor: BigInt(0),
            payment_tax_minor: BigInt(0),
            payment_service_charge_minor: BigInt(0),
            payment_total_minor: BigInt(0),
            active_table_guard: dto.tableId,
            opened_at: now,
            created_at: now,
            updated_at: now,
          },
        });

        await tx.session_auth_token.create({
          data: {
            id: tokenId,
            session_id: sessionId,
            token_hash: tokenHash,
            expires_at: tokenExpiresAt,
            created_at: now,
          },
        });

        await tx.session_timeline_event.create({
          data: {
            id: uuidv4(),
            session_id: sessionId,
            event_type: 'session_opened',
            payload_json: {
              displayNumber,
              tableId: dto.tableId,
              openedVia: dto.openedVia,
            },
            actor_type: 'user',
            actor_id: openedByUserId,
            occurred_at: now,
          },
        });

        return created;
      });

      const token = await this.prisma.session_auth_token.findUniqueOrThrow({
        where: { id: tokenId },
      });

      return {
        snapshot: mapSessionSnapshot({
          session,
          activeToken: token,
          tableLabel: table.label,
        }),
        sessionToken,
      };
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw conflict(
          'ACTIVE_SESSION_EXISTS',
          'Table already has an active session',
        );
      }
      throw err;
    }
  }

  async join(
    sessionToken: string,
    deviceId?: string,
  ): Promise<SessionSnapshot> {
    const snapshot = await this.resolveByToken(sessionToken);
    if (snapshot.session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is closed');
    }

    const now = new Date();
    if (deviceId?.trim()) {
      await this.prisma.session_device.upsert({
        where: {
          session_id_device_fingerprint: {
            session_id: snapshot.session.id,
            device_fingerprint: deviceId.trim(),
          },
        },
        create: {
          id: uuidv4(),
          session_id: snapshot.session.id,
          device_fingerprint: deviceId.trim(),
          last_seen_at: now,
          created_at: now,
        },
        update: { last_seen_at: now },
      });
    }

    await this.prisma.session_timeline_event.create({
      data: {
        id: uuidv4(),
        session_id: snapshot.session.id,
        event_type: 'device_joined',
        payload_json: deviceId ? { deviceId } : {},
        actor_type: 'customer_session',
        actor_id: null,
        occurred_at: now,
      },
    });

    return this.getSnapshotById(
      snapshot.session.restaurantId,
      snapshot.session.id,
    );
  }

  async me(sessionToken: string): Promise<SessionSnapshot> {
    return this.resolveByToken(sessionToken);
  }

  async findById(
    restaurantId: string,
    sessionId: string,
  ): Promise<SessionSnapshot> {
    return this.getSnapshotById(restaurantId, sessionId);
  }

  async reissueToken(
    restaurantId: string,
    sessionId: string,
  ): Promise<{
    sessionToken: string;
    expiresAt: string;
    snapshot: SessionSnapshot;
  }> {
    const session = await this.requireSession(restaurantId, sessionId);
    if (session.status !== 'open' && session.status !== 'payment_pending') {
      throw unprocessable(
        'SESSION_NOT_REISSUABLE',
        'Only open or payment_pending sessions can reissue tokens',
      );
    }

    const settings = await this.prisma.restaurantSettings.findUnique({
      where: { restaurantId },
    });
    const ttlMinutes = settings?.sessionTokenTtlMinutes ?? 480;
    const now = new Date();
    const sessionToken = generateOpaqueToken(32);
    const tokenExpiresAt = new Date(now.getTime() + ttlMinutes * 60_000);
    const tokenId = uuidv4();
    const tokenHash = sha256Hex(sessionToken);

    await this.prisma.$transaction(async (tx) => {
      await tx.session_auth_token.updateMany({
        where: { session_id: sessionId, revoked_at: null },
        data: { revoked_at: now },
      });

      await tx.session_auth_token.create({
        data: {
          id: tokenId,
          session_id: sessionId,
          token_hash: tokenHash,
          expires_at: tokenExpiresAt,
          created_at: now,
        },
      });

      await tx.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'session_token_reissued',
          payload_json: {},
          actor_type: 'user',
          actor_id: null,
          occurred_at: now,
        },
      });
    });

    const snapshot = await this.getSnapshotById(restaurantId, sessionId);
    return {
      sessionToken,
      expiresAt: tokenExpiresAt.toISOString(),
      snapshot,
    };
  }

  async listActive(restaurantId: string): Promise<{ items: SessionSnapshot[] }> {
    const sessions = await this.prisma.dine_in_session.findMany({
      where: {
        restaurant_id: restaurantId,
        status: { in: ['open', 'payment_pending'] },
      },
      orderBy: { opened_at: 'asc' },
      include: {
        restaurant_table: true,
        session_auth_token: {
          where: { revoked_at: null },
          orderBy: { created_at: 'desc' },
          take: 1,
        },
        kitchen_batch: { select: { id: true } },
        staff_request: { select: { id: true } },
      },
    });

    return {
      items: sessions.map((s) =>
        mapSessionSnapshot({
          session: s,
          activeToken: s.session_auth_token[0] ?? null,
          tableLabel: s.restaurant_table.label,
          batchIds: s.kitchen_batch.map((b) => b.id),
          requestIds: s.staff_request.map((r) => r.id),
        }),
      ),
    };
  }

  async findActiveByTable(
    restaurantId: string,
    tableId: string,
  ): Promise<{ session: SessionSnapshot | null }> {
    const session = await this.prisma.dine_in_session.findFirst({
      where: {
        restaurant_id: restaurantId,
        table_id: tableId,
        active_table_guard: tableId,
        status: { in: ['open', 'payment_pending'] },
      },
      include: {
        restaurant_table: true,
        session_auth_token: {
          where: { revoked_at: null },
          orderBy: { created_at: 'desc' },
          take: 1,
        },
        kitchen_batch: { select: { id: true } },
        staff_request: { select: { id: true } },
      },
    });

    if (!session) {
      return { session: null };
    }

    return {
      session: mapSessionSnapshot({
        session,
        activeToken: session.session_auth_token[0] ?? null,
        tableLabel: session.restaurant_table.label,
        batchIds: session.kitchen_batch.map((b) => b.id),
        requestIds: session.staff_request.map((r) => r.id),
      }),
    };
  }

  async markWaitingPayment(
    restaurantId: string,
    sessionId: string,
  ): Promise<SessionSnapshot> {
    const session = await this.requireSession(restaurantId, sessionId);
    if (session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is closed');
    }
    if (session.status === 'payment_pending') {
      throw conflict(
        'ALREADY_WAITING_PAYMENT',
        'Session is already waiting for payment',
      );
    }
    if (session.status !== 'open') {
      throw unprocessable(
        'INVALID_TRANSITION',
        'Cannot mark waiting payment from current status',
      );
    }

    const settings = await this.prisma.restaurantSettings.findUnique({
      where: { restaurantId },
    });
    const softLock = settings?.paymentSoftLockEnabled ?? true;
    const now = new Date();

    await this.prisma.$transaction([
      this.prisma.dine_in_session.update({
        where: { id: sessionId },
        data: {
          status: 'payment_pending',
          payment_status: 'waiting_payment',
          payment_soft_lock: softLock,
          updated_at: now,
        },
      }),
      this.prisma.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'payment_requested',
          payload_json: { phase: 'waiting_payment' },
          actor_type: 'user',
          actor_id: null,
          occurred_at: now,
        },
      }),
    ]);

    return this.getSnapshotById(restaurantId, sessionId);
  }

  async close(
    restaurantId: string,
    sessionId: string,
    closedByUserId: string,
  ): Promise<SessionSnapshot> {
    const session = await this.requireSession(restaurantId, sessionId);
    if (session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is already closed');
    }

    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      await tx.dine_in_session.update({
        where: { id: sessionId },
        data: {
          status: 'closed',
          closed_by_user_id: closedByUserId,
          closed_at: now,
          active_table_guard: null,
          payment_soft_lock: false,
          updated_at: now,
        },
      });

      await tx.restaurantTable.update({
        where: { id: session.table_id },
        data: { status: 'available', updatedAt: now },
      });

      await tx.session_auth_token.updateMany({
        where: { session_id: sessionId, revoked_at: null },
        data: { revoked_at: now },
      });

      await tx.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'payment_closed',
          payload_json: { closeType: 'engine_close' },
          actor_type: 'user',
          actor_id: closedByUserId,
          occurred_at: now,
        },
      });
    });

    return this.getSnapshotById(restaurantId, sessionId);
  }

  transfer(): never {
    throw notImplemented(
      'SESSION_TRANSFER_UNSUPPORTED',
      'Session transfer is not supported until Phase 2',
    );
  }

  async nextDailySequence(
    restaurantId: string,
    dateKey: string,
  ): Promise<{ nextSequence: number }> {
    if (!/^\d{8}$/.test(dateKey)) {
      throw unprocessable('INVALID_DATE_KEY', 'dateKey must be YYYYMMDD');
    }
    const next = await this.allocateDailySequence(restaurantId, dateKey);
    return { nextSequence: next };
  }

  async update(
    restaurantId: string,
    sessionId: string,
    dto: UpdateSessionDto,
  ): Promise<SessionSnapshot> {
    await this.requireSession(restaurantId, sessionId);
    const now = new Date();
    const data: Prisma.dine_in_sessionUpdateInput = { updated_at: now };

    if (dto.status != null) data.status = dto.status;
    if (dto.paymentStatus != null) data.payment_status = dto.paymentStatus;
    if (dto.currentBatchNumber != null) {
      data.current_batch_number = dto.currentBatchNumber;
    }
    if (dto.paymentSoftLock != null) {
      data.payment_soft_lock = dto.paymentSoftLock;
    }
    if (dto.paymentSummary) {
      const ps = dto.paymentSummary;
      if (ps.subtotalMinor != null) {
        data.payment_subtotal_minor = BigInt(ps.subtotalMinor);
      }
      if (ps.discountMinor != null) {
        data.payment_discount_minor = BigInt(ps.discountMinor);
      }
      if (ps.taxMinor != null) {
        data.payment_tax_minor = BigInt(ps.taxMinor);
      }
      if (ps.serviceChargeMinor != null) {
        data.payment_service_charge_minor = BigInt(ps.serviceChargeMinor);
      }
      if (ps.totalMinor != null) {
        data.payment_total_minor = BigInt(ps.totalMinor);
      }
    }

    await this.prisma.dine_in_session.update({
      where: { id: sessionId },
      data,
    });

    return this.getSnapshotById(restaurantId, sessionId);
  }

  async appendTimeline(
    restaurantId: string,
    sessionId: string,
    dto: AppendTimelineDto,
    actorUserId?: string,
  ): Promise<{ id: string }> {
    await this.requireSession(restaurantId, sessionId);
    const id = dto.id?.trim() || uuidv4();
    const occurredAt = dto.occurredAt ? new Date(dto.occurredAt) : new Date();

    await this.prisma.session_timeline_event.create({
      data: {
        id,
        session_id: sessionId,
        event_type: dto.eventType,
        payload_json: (dto.payloadJson ?? {}) as Prisma.InputJsonValue,
        actor_type: dto.actorType ?? 'user',
        actor_id: dto.actorId ?? actorUserId ?? null,
        occurred_at: occurredAt,
      },
    });

    return { id };
  }

  async getBill(
    restaurantId: string,
    sessionId: string,
  ): Promise<{
    sessionId: string;
    paymentStatus: string;
    paymentSummary: {
      subtotalMinor: number;
      discountMinor: number;
      taxMinor: number;
      serviceChargeMinor: number;
      totalMinor: number;
    };
  }> {
    const session = await this.requireSession(restaurantId, sessionId);
    return {
      sessionId: session.id,
      paymentStatus: session.payment_status,
      paymentSummary: {
        subtotalMinor: toNumber(session.payment_subtotal_minor),
        discountMinor: toNumber(session.payment_discount_minor),
        taxMinor: toNumber(session.payment_tax_minor),
        serviceChargeMinor: toNumber(session.payment_service_charge_minor),
        totalMinor: toNumber(session.payment_total_minor),
      },
    };
  }

  async nextBatchNumber(
    restaurantId: string,
    sessionId: string,
  ): Promise<{ nextBatchNumber: number }> {
    const session = await this.requireSession(restaurantId, sessionId);
    if (session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is closed');
    }

    const now = new Date();
    const next = session.current_batch_number + 1;

    await this.prisma.$transaction([
      this.prisma.dine_in_session.update({
        where: { id: sessionId },
        data: {
          current_batch_number: next,
          updated_at: now,
        },
      }),
      this.prisma.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'batch_confirmed',
          payload_json: { batchNumber: next },
          actor_type: 'system',
          actor_id: null,
          occurred_at: now,
        },
      }),
    ]);

    return { nextBatchNumber: next };
  }

  private async allocateDailySequence(
    restaurantId: string,
    dateKey: string,
  ): Promise<number> {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id: restaurantId },
    });
    if (!restaurant) {
      throw notFound('RESTAURANT_NOT_FOUND', 'Restaurant not found');
    }

    const counterType = 'session';
    const result = await this.prisma.$transaction(async (tx) => {
      const existing = await tx.restaurant_daily_counter.findUnique({
        where: {
          restaurant_id_date_key_counter_type: {
            restaurant_id: restaurantId,
            date_key: dateKey,
            counter_type: counterType,
          },
        },
      });

      if (!existing) {
        const created = await tx.restaurant_daily_counter.create({
          data: {
            id: uuidv4(),
            restaurant_id: restaurantId,
            date_key: dateKey,
            counter_type: counterType,
            current_value: BigInt(1),
            updated_at: new Date(),
          },
        });
        return toNumber(created.current_value);
      }

      const updated = await tx.restaurant_daily_counter.update({
        where: { id: existing.id },
        data: {
          current_value: { increment: BigInt(1) },
          updated_at: new Date(),
        },
      });
      return toNumber(updated.current_value);
    });

    return result;
  }

  private async resolveByToken(sessionToken: string): Promise<SessionSnapshot> {
    const tokenHash = sha256Hex(sessionToken);
    const row = await this.prisma.session_auth_token.findUnique({
      where: { token_hash: tokenHash },
      include: {
        dine_in_session: {
      include: {
        restaurant_table: true,
        restaurant: { select: { settings: true } },
        kitchen_batch: { select: { id: true } },
        staff_request: { select: { id: true } },
      },
        },
      },
    });

    if (!row || row.revoked_at) {
      throw unauthorized('INVALID_SESSION_TOKEN', 'Invalid session token');
    }
    if (row.expires_at.getTime() <= Date.now()) {
      throw unauthorized('SESSION_TOKEN_EXPIRED', 'Session token expired');
    }

    const session = row.dine_in_session;
    const { paidMinor, outstandingMinor } = await this.calculateBalance(session.id, session.restaurant.settings);

    return mapSessionSnapshot({
      session,
      activeToken: row,
      tableLabel: session.restaurant_table.label,
      batchIds: session.kitchen_batch.map((b) => b.id),
      requestIds: session.staff_request.map((r) => r.id),
      paidMinor,
      outstandingMinor,
    });
  }

  private async requireSession(restaurantId: string, sessionId: string) {
    const session = await this.prisma.dine_in_session.findFirst({
      where: { id: sessionId, restaurant_id: restaurantId },
    });
    if (!session) {
      throw notFound('SESSION_NOT_FOUND', 'Session not found');
    }
    return session;
  }

  private async getSnapshotById(
    restaurantId: string,
    sessionId: string,
  ): Promise<SessionSnapshot> {
    const session = await this.prisma.dine_in_session.findFirst({
      where: { id: sessionId, restaurant_id: restaurantId },
      include: {
        restaurant_table: true,
        restaurant: { select: { settings: true } },
        session_auth_token: {
          where: { revoked_at: null },
          orderBy: { created_at: 'desc' },
          take: 1,
        },
        kitchen_batch: { select: { id: true } },
        staff_request: { select: { id: true } },
      },
    });
    if (!session) {
      throw notFound('SESSION_NOT_FOUND', 'Session not found');
    }

    const { paidMinor, outstandingMinor } = await this.calculateBalance(sessionId, session.restaurant.settings);

    return mapSessionSnapshot({
      session,
      activeToken: session.session_auth_token[0] ?? null,
      tableLabel: session.restaurant_table.label,
      batchIds: session.kitchen_batch.map((b) => b.id),
      requestIds: session.staff_request.map((r) => r.id),
      paidMinor,
      outstandingMinor,
    });
  }

  private async calculateBalance(sessionId: string, settings: any): Promise<{ paidMinor: number; outstandingMinor: number }> {
    if (!settings) return { paidMinor: 0, outstandingMinor: 0 };
    const batchItems = await this.prisma.batch_item.findMany({
      where: { kitchen_batch: { session_id: sessionId } },
    });
    let subtotalMinor = 0n;
    for (const i of batchItems) subtotalMinor += i.line_total_minor;
    
    const taxAmountMinor = (subtotalMinor * BigInt(settings.taxRateBps) + 5000n) / 10000n;
    const serviceChargeMinor = (subtotalMinor * BigInt(settings.serviceChargeBps) + 5000n) / 10000n;
    const totalAmountMinor = subtotalMinor + taxAmountMinor + serviceChargeMinor;

    const payments = await this.prisma.session_payment.findMany({
      where: { session_id: sessionId, payment_status: 'paid' },
    });
    const paidMinor = payments.reduce((s, p) => s + p.total_amount_minor, 0n);
    const outstanding = totalAmountMinor - paidMinor;

    return {
      paidMinor: Number(paidMinor),
      outstandingMinor: Number(outstanding > 0n ? outstanding : 0n),
    };
  }
}

function formatDateKey(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}${m}${d}`;
}
