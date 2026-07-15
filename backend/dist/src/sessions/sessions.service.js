"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SessionsService = void 0;
const common_1 = require("@nestjs/common");
const client_1 = require("@prisma/client");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const token_hash_1 = require("../common/crypto/token-hash");
const big_int_1 = require("../common/utils/big-int");
const prisma_service_1 = require("../prisma/prisma.service");
const session_snapshot_mapper_1 = require("./session-snapshot.mapper");
let SessionsService = class SessionsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(restaurantId, openedByUserId, dto) {
        const table = await this.prisma.restaurantTable.findFirst({
            where: { id: dto.tableId, restaurantId },
        });
        if (!table) {
            throw (0, api_exception_1.notFound)('TABLE_NOT_FOUND', 'Table not found');
        }
        if (!table.isActive) {
            throw (0, api_exception_1.unprocessable)('TABLE_INACTIVE', 'Table is inactive');
        }
        if (table.status === 'reserved') {
            throw (0, api_exception_1.unprocessable)('TABLE_RESERVED', 'Table is reserved');
        }
        const existing = await this.prisma.dine_in_session.findFirst({
            where: {
                restaurant_id: restaurantId,
                table_id: dto.tableId,
                active_table_guard: dto.tableId,
            },
        });
        if (existing) {
            throw (0, api_exception_1.conflict)('ACTIVE_SESSION_EXISTS', 'Table already has an active session');
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
        const displayNumber = dto.displayNumber?.trim() ||
            `S-${String(sessionSequence).padStart(4, '0')}`;
        const sessionToken = dto.sessionToken?.trim() || (0, token_hash_1.generateOpaqueToken)(32);
        const tokenExpiresAt = dto.tokenExpiresAt
            ? new Date(dto.tokenExpiresAt)
            : new Date(now.getTime() + ttlMinutes * 60_000);
        const sessionId = (0, uuid_1.v4)();
        const tokenId = (0, uuid_1.v4)();
        const tokenHash = (0, token_hash_1.sha256Hex)(sessionToken);
        try {
            const session = await this.prisma.$transaction(async (tx) => {
                const stillActive = await tx.dine_in_session.findFirst({
                    where: {
                        restaurant_id: restaurantId,
                        active_table_guard: dto.tableId,
                    },
                });
                if (stillActive) {
                    throw (0, api_exception_1.conflict)('ACTIVE_SESSION_EXISTS', 'Table already has an active session');
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
                        session_number: BigInt(sessionSequence),
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
                        id: (0, uuid_1.v4)(),
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
                snapshot: (0, session_snapshot_mapper_1.mapSessionSnapshot)({
                    session,
                    activeToken: token,
                    tableLabel: table.label,
                }),
                sessionToken,
            };
        }
        catch (err) {
            if (err instanceof client_1.Prisma.PrismaClientKnownRequestError &&
                err.code === 'P2002') {
                throw (0, api_exception_1.conflict)('ACTIVE_SESSION_EXISTS', 'Table already has an active session');
            }
            throw err;
        }
    }
    async join(sessionToken, deviceId) {
        const snapshot = await this.resolveByToken(sessionToken);
        if (snapshot.session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
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
                    id: (0, uuid_1.v4)(),
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
                id: (0, uuid_1.v4)(),
                session_id: snapshot.session.id,
                event_type: 'device_joined',
                payload_json: deviceId ? { deviceId } : {},
                actor_type: 'customer_session',
                actor_id: null,
                occurred_at: now,
            },
        });
        return this.getSnapshotById(snapshot.session.restaurantId, snapshot.session.id);
    }
    async me(sessionToken) {
        return this.resolveByToken(sessionToken);
    }
    async findById(restaurantId, sessionId) {
        return this.getSnapshotById(restaurantId, sessionId);
    }
    async listActive(restaurantId) {
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
            items: sessions.map((s) => (0, session_snapshot_mapper_1.mapSessionSnapshot)({
                session: s,
                activeToken: s.session_auth_token[0] ?? null,
                tableLabel: s.restaurant_table.label,
                batchIds: s.kitchen_batch.map((b) => b.id),
                requestIds: s.staff_request.map((r) => r.id),
            })),
        };
    }
    async findActiveByTable(restaurantId, tableId) {
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
            session: (0, session_snapshot_mapper_1.mapSessionSnapshot)({
                session,
                activeToken: session.session_auth_token[0] ?? null,
                tableLabel: session.restaurant_table.label,
                batchIds: session.kitchen_batch.map((b) => b.id),
                requestIds: session.staff_request.map((r) => r.id),
            }),
        };
    }
    async markWaitingPayment(restaurantId, sessionId) {
        const session = await this.requireSession(restaurantId, sessionId);
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
        }
        if (session.status === 'payment_pending') {
            throw (0, api_exception_1.conflict)('ALREADY_WAITING_PAYMENT', 'Session is already waiting for payment');
        }
        if (session.status !== 'open') {
            throw (0, api_exception_1.unprocessable)('INVALID_TRANSITION', 'Cannot mark waiting payment from current status');
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
                    id: (0, uuid_1.v4)(),
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
    async close(restaurantId, sessionId, closedByUserId) {
        const session = await this.requireSession(restaurantId, sessionId);
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is already closed');
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
                    id: (0, uuid_1.v4)(),
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
    transfer() {
        throw (0, api_exception_1.notImplemented)('SESSION_TRANSFER_UNSUPPORTED', 'Session transfer is not supported until Phase 2');
    }
    async nextDailySequence(restaurantId, dateKey) {
        if (!/^\d{8}$/.test(dateKey)) {
            throw (0, api_exception_1.unprocessable)('INVALID_DATE_KEY', 'dateKey must be YYYYMMDD');
        }
        const next = await this.allocateDailySequence(restaurantId, dateKey);
        return { nextSequence: next };
    }
    async update(restaurantId, sessionId, dto) {
        await this.requireSession(restaurantId, sessionId);
        const now = new Date();
        const data = { updated_at: now };
        if (dto.status != null)
            data.status = dto.status;
        if (dto.paymentStatus != null)
            data.payment_status = dto.paymentStatus;
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
    async appendTimeline(restaurantId, sessionId, dto, actorUserId) {
        await this.requireSession(restaurantId, sessionId);
        const id = dto.id?.trim() || (0, uuid_1.v4)();
        const occurredAt = dto.occurredAt ? new Date(dto.occurredAt) : new Date();
        await this.prisma.session_timeline_event.create({
            data: {
                id,
                session_id: sessionId,
                event_type: dto.eventType,
                payload_json: (dto.payloadJson ?? {}),
                actor_type: dto.actorType ?? 'user',
                actor_id: dto.actorId ?? actorUserId ?? null,
                occurred_at: occurredAt,
            },
        });
        return { id };
    }
    async getBill(restaurantId, sessionId) {
        const session = await this.requireSession(restaurantId, sessionId);
        return {
            sessionId: session.id,
            paymentStatus: session.payment_status,
            paymentSummary: {
                subtotalMinor: (0, big_int_1.toNumber)(session.payment_subtotal_minor),
                discountMinor: (0, big_int_1.toNumber)(session.payment_discount_minor),
                taxMinor: (0, big_int_1.toNumber)(session.payment_tax_minor),
                serviceChargeMinor: (0, big_int_1.toNumber)(session.payment_service_charge_minor),
                totalMinor: (0, big_int_1.toNumber)(session.payment_total_minor),
            },
        };
    }
    async nextBatchNumber(restaurantId, sessionId) {
        const session = await this.requireSession(restaurantId, sessionId);
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
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
                    id: (0, uuid_1.v4)(),
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
    async allocateDailySequence(restaurantId, dateKey) {
        const restaurant = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
        });
        if (!restaurant) {
            throw (0, api_exception_1.notFound)('RESTAURANT_NOT_FOUND', 'Restaurant not found');
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
                        id: (0, uuid_1.v4)(),
                        restaurant_id: restaurantId,
                        date_key: dateKey,
                        counter_type: counterType,
                        current_value: BigInt(1),
                        updated_at: new Date(),
                    },
                });
                return (0, big_int_1.toNumber)(created.current_value);
            }
            const updated = await tx.restaurant_daily_counter.update({
                where: { id: existing.id },
                data: {
                    current_value: { increment: BigInt(1) },
                    updated_at: new Date(),
                },
            });
            return (0, big_int_1.toNumber)(updated.current_value);
        });
        return result;
    }
    async resolveByToken(sessionToken) {
        const tokenHash = (0, token_hash_1.sha256Hex)(sessionToken);
        const row = await this.prisma.session_auth_token.findUnique({
            where: { token_hash: tokenHash },
            include: {
                dine_in_session: {
                    include: {
                        restaurant_table: true,
                        kitchen_batch: { select: { id: true } },
                        staff_request: { select: { id: true } },
                    },
                },
            },
        });
        if (!row || row.revoked_at) {
            throw (0, api_exception_1.unauthorized)('INVALID_SESSION_TOKEN', 'Invalid session token');
        }
        if (row.expires_at.getTime() <= Date.now()) {
            throw (0, api_exception_1.unauthorized)('SESSION_TOKEN_EXPIRED', 'Session token expired');
        }
        const session = row.dine_in_session;
        return (0, session_snapshot_mapper_1.mapSessionSnapshot)({
            session,
            activeToken: row,
            tableLabel: session.restaurant_table.label,
            batchIds: session.kitchen_batch.map((b) => b.id),
            requestIds: session.staff_request.map((r) => r.id),
        });
    }
    async requireSession(restaurantId, sessionId) {
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
        });
        if (!session) {
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        return session;
    }
    async getSnapshotById(restaurantId, sessionId) {
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
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
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        return (0, session_snapshot_mapper_1.mapSessionSnapshot)({
            session,
            activeToken: session.session_auth_token[0] ?? null,
            tableLabel: session.restaurant_table.label,
            batchIds: session.kitchen_batch.map((b) => b.id),
            requestIds: session.staff_request.map((r) => r.id),
        });
    }
};
exports.SessionsService = SessionsService;
exports.SessionsService = SessionsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SessionsService);
function formatDateKey(date) {
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    return `${y}${m}${d}`;
}
//# sourceMappingURL=sessions.service.js.map