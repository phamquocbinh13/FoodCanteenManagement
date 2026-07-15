import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';
import {
  conflict,
  notFound,
  unprocessable,
} from '../common/errors/api-exception';
import { PrismaService } from '../prisma/prisma.service';
import { SessionsService } from '../sessions/sessions.service';
import type { SessionSnapshot } from '../sessions/session-snapshot.mapper';
import { CreateSessionPaymentDto } from './dto/create-session-payment.dto';
import {
  computeBillMinors,
  mapSessionBillLine,
  mapSessionPayment,
  type SessionBillLineDto,
  type SessionPaymentDto,
} from './payments.mapper';

export type CreatePaymentResult = {
  payment: SessionPaymentDto;
  billLines: SessionBillLineDto[];
  snapshot: SessionSnapshot;
};

@Injectable()
export class PaymentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly sessions: SessionsService,
  ) {}

  async create(
    restaurantId: string,
    sessionId: string,
    closedByUserId: string,
    dto: CreateSessionPaymentDto,
  ): Promise<CreatePaymentResult> {
    if (dto.closeType === 'force_closed' && !dto.forceCloseReason) {
      throw unprocessable(
        'FORCE_CLOSE_REASON_REQUIRED',
        'forceCloseReason is required when closeType is force_closed',
      );
    }
    if (dto.closeType === 'payment' && dto.forceCloseReason) {
      throw unprocessable(
        'FORCE_CLOSE_REASON_NOT_ALLOWED',
        'forceCloseReason must be omitted when closeType is payment',
      );
    }

    const result = await this.prisma.$transaction(async (tx) => {
      const session = await tx.dine_in_session.findFirst({
        where: { id: sessionId, restaurant_id: restaurantId },
      });
      if (!session) {
        throw notFound('SESSION_NOT_FOUND', 'Session not found');
      }
      if (session.status === 'closed') {
        throw conflict('SESSION_CLOSED', 'Session is already closed');
      }

      const existingPayment = await tx.session_payment.findUnique({
        where: { session_id: sessionId },
      });
      if (existingPayment) {
        throw conflict(
          'SESSION_ALREADY_PAID',
          'Session already has a payment — no split bill',
        );
      }

      const settings = await tx.restaurantSettings.findUnique({
        where: { restaurantId },
      });
      if (!settings) {
        throw notFound(
          'RESTAURANT_SETTINGS_NOT_FOUND',
          'Restaurant settings not found',
        );
      }

      const batchItems = await tx.batch_item.findMany({
        where: {
          kitchen_batch: { session_id: sessionId },
        },
        orderBy: { created_at: 'asc' },
      });

      const bill = computeBillMinors({
        lineTotals: batchItems.map((i) => i.line_total_minor),
        taxRateBps: settings.taxRateBps,
        serviceChargeBps: settings.serviceChargeBps,
      });

      const currency = settings.defaultCurrency;
      const now = new Date();
      const paymentId = uuidv4();

      const payment = await tx.session_payment.create({
        data: {
          id: paymentId,
          session_id: sessionId,
          payment_method: dto.paymentMethod,
          close_type: dto.closeType,
          force_close_reason:
            dto.closeType === 'force_closed' ? dto.forceCloseReason! : null,
          force_close_note: dto.forceCloseNote?.trim() || null,
          subtotal_minor: bill.subtotalMinor,
          tax_amount_minor: bill.taxAmountMinor,
          service_charge_minor: bill.serviceChargeMinor,
          total_amount_minor: bill.totalAmountMinor,
          currency_code: currency,
          closed_by_user_id: closedByUserId,
          paid_at: now,
          created_at: now,
        },
      });

      const billLineRows: Prisma.session_bill_lineCreateManyInput[] =
        batchItems.map((item) => ({
          id: uuidv4(),
          session_payment_id: paymentId,
          batch_item_id: item.id,
          description: item.menu_item_name_snapshot,
          quantity: item.quantity,
          unit_price_minor: item.unit_price_minor,
          line_total_minor: item.line_total_minor,
          currency_code: item.currency_code || currency,
          created_at: now,
        }));

      if (billLineRows.length > 0) {
        await tx.session_bill_line.createMany({ data: billLineRows });
      }

      const createdLines =
        billLineRows.length > 0
          ? await tx.session_bill_line.findMany({
              where: { session_payment_id: paymentId },
              orderBy: { created_at: 'asc' },
            })
          : [];

      const closed = await tx.dine_in_session.updateMany({
        where: {
          id: sessionId,
          restaurant_id: restaurantId,
          status: { not: 'closed' },
        },
        data: {
          status: 'closed',
          payment_status: 'paid',
          active_table_guard: null,
          payment_soft_lock: false,
          closed_at: now,
          closed_by_user_id: closedByUserId,
          payment_subtotal_minor: bill.subtotalMinor,
          payment_tax_minor: bill.taxAmountMinor,
          payment_service_charge_minor: bill.serviceChargeMinor,
          payment_total_minor: bill.totalAmountMinor,
          updated_at: now,
        },
      });
      if (closed.count !== 1) {
        throw conflict('SESSION_CLOSED', 'Session is already closed');
      }

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
          payload_json: {
            closeType: dto.closeType,
            paymentId,
            paymentMethod: dto.paymentMethod,
            ...(dto.closeType === 'force_closed'
              ? {
                  forceCloseReason: dto.forceCloseReason,
                  forceCloseNote: dto.forceCloseNote ?? null,
                }
              : {}),
          },
          actor_type: 'user',
          actor_id: closedByUserId,
          occurred_at: now,
        },
      });

      return { payment, billLines: createdLines };
    });

    const snapshot = await this.sessions.findById(restaurantId, sessionId);

    return {
      payment: mapSessionPayment(result.payment),
      billLines: result.billLines.map(mapSessionBillLine),
      snapshot,
    };
  }
}
