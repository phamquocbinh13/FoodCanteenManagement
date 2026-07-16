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
exports.PaymentsService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const prisma_service_1 = require("../prisma/prisma.service");
const sessions_service_1 = require("../sessions/sessions.service");
const payments_mapper_1 = require("./payments.mapper");
let PaymentsService = class PaymentsService {
    prisma;
    sessions;
    constructor(prisma, sessions) {
        this.prisma = prisma;
        this.sessions = sessions;
    }
    async create(restaurantId, sessionId, closedByUserId, dto) {
        if (dto.closeType === 'force_closed' && !dto.forceCloseReason) {
            throw (0, api_exception_1.unprocessable)('FORCE_CLOSE_REASON_REQUIRED', 'forceCloseReason is required when closeType is force_closed');
        }
        if (dto.closeType === 'payment' && dto.forceCloseReason) {
            throw (0, api_exception_1.unprocessable)('FORCE_CLOSE_REASON_NOT_ALLOWED', 'forceCloseReason must be omitted when closeType is payment');
        }
        const result = await this.prisma.$transaction(async (tx) => {
            const session = await tx.dine_in_session.findFirst({
                where: { id: sessionId, restaurant_id: restaurantId },
            });
            if (!session) {
                throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
            }
            if (session.status === 'closed') {
                throw (0, api_exception_1.conflict)('SESSION_CLOSED', 'Session is already closed');
            }
            const settings = await tx.restaurantSettings.findUnique({
                where: { restaurantId },
            });
            if (!settings) {
                throw (0, api_exception_1.notFound)('RESTAURANT_SETTINGS_NOT_FOUND', 'Restaurant settings not found');
            }
            const batchItems = await tx.batch_item.findMany({
                where: {
                    kitchen_batch: { session_id: sessionId },
                },
                orderBy: { created_at: 'asc' },
            });
            const bill = (0, payments_mapper_1.computeBillMinors)({
                lineTotals: batchItems.map((i) => i.line_total_minor),
                taxRateBps: settings.taxRateBps,
                serviceChargeBps: settings.serviceChargeBps,
            });
            const payments = await tx.session_payment.findMany({
                where: { session_id: sessionId, payment_status: 'paid' },
            });
            const paidMinor = payments.reduce((sum, p) => sum + p.total_amount_minor, 0n);
            const outstandingMinor = bill.totalAmountMinor - paidMinor;
            if (dto.closeType === 'payment' && outstandingMinor <= 0n) {
            }
            const currency = settings.defaultCurrency;
            const now = new Date();
            let paymentId;
            let createdPayment;
            const createdLines = [];
            if (outstandingMinor > 0n || dto.closeType === 'force_closed') {
                paymentId = (0, uuid_1.v4)();
                const payAmount = outstandingMinor > 0n ? outstandingMinor : 0n;
                createdPayment = await tx.session_payment.create({
                    data: {
                        id: paymentId,
                        session_id: sessionId,
                        payment_method: dto.paymentMethod,
                        close_type: dto.closeType,
                        force_close_reason: dto.closeType === 'force_closed' ? dto.forceCloseReason : null,
                        force_close_note: dto.forceCloseNote?.trim() || null,
                        subtotal_minor: payAmount,
                        tax_amount_minor: 0n,
                        service_charge_minor: 0n,
                        total_amount_minor: payAmount,
                        currency_code: currency,
                        closed_by_user_id: closedByUserId,
                        payment_status: 'paid',
                        payment_provider: 'cash',
                        paid_at: now,
                        created_at: now,
                    },
                });
                const lineId = (0, uuid_1.v4)();
                await tx.session_bill_line.create({
                    data: {
                        id: lineId,
                        session_payment_id: paymentId,
                        batch_item_id: batchItems[0]?.id || (0, uuid_1.v4)(),
                        description: 'Payment',
                        quantity: 1,
                        unit_price_minor: payAmount,
                        line_total_minor: payAmount,
                        currency_code: currency,
                        created_at: now,
                    }
                });
                const line = await tx.session_bill_line.findUnique({ where: { id: lineId } });
                if (line)
                    createdLines.push(line);
            }
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
                throw (0, api_exception_1.conflict)('SESSION_CLOSED', 'Session is already closed');
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
                    id: (0, uuid_1.v4)(),
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
            return { payment: createdPayment, billLines: createdLines };
        });
        const snapshot = await this.sessions.findById(restaurantId, sessionId);
        return {
            payment: result.payment ? (0, payments_mapper_1.mapSessionPayment)(result.payment) : null,
            billLines: result.billLines.map(payments_mapper_1.mapSessionBillLine),
            snapshot,
        };
    }
    async calculateSessionBalance(sessionId) {
        const session = await this.prisma.dine_in_session.findUnique({
            where: { id: sessionId },
            include: {
                restaurant: { select: { settings: true } }
            }
        });
        if (!session || !session.restaurant?.settings) {
            return { totalMinor: 0n, paidMinor: 0n, outstandingMinor: 0n };
        }
        const batchItems = await this.prisma.batch_item.findMany({
            where: { kitchen_batch: { session_id: sessionId } },
        });
        const bill = (0, payments_mapper_1.computeBillMinors)({
            lineTotals: batchItems.map((i) => i.line_total_minor),
            taxRateBps: session.restaurant.settings.taxRateBps,
            serviceChargeBps: session.restaurant.settings.serviceChargeBps,
        });
        const payments = await this.prisma.session_payment.findMany({
            where: { session_id: sessionId, payment_status: 'paid' },
        });
        const paidMinor = payments.reduce((sum, p) => sum + p.total_amount_minor, 0n);
        const outstandingMinor = bill.totalAmountMinor - paidMinor;
        return {
            totalMinor: bill.totalAmountMinor,
            paidMinor,
            outstandingMinor: outstandingMinor > 0n ? outstandingMinor : 0n,
        };
    }
    async confirmPaymentOnWebhookSuccess(sessionId, paymentId) {
        await this.prisma.$transaction(async (tx) => {
            const payment = await tx.session_payment.findUnique({ where: { id: paymentId } });
            if (!payment || payment.payment_status === 'paid')
                return;
            const session = await tx.dine_in_session.findUnique({ where: { id: sessionId } });
            if (!session)
                return;
            const now = new Date();
            const batchItems = await tx.batch_item.findMany({
                where: { kitchen_batch: { session_id: sessionId } },
                orderBy: { created_at: 'asc' },
            });
            const billLineRows = batchItems.map((item) => ({
                id: (0, uuid_1.v4)(),
                session_payment_id: paymentId,
                batch_item_id: item.id,
                description: item.menu_item_name_snapshot,
                quantity: item.quantity,
                unit_price_minor: item.unit_price_minor,
                line_total_minor: item.line_total_minor,
                currency_code: item.currency_code || payment.currency_code,
                created_at: now,
            }));
            if (billLineRows.length > 0) {
                await tx.session_bill_line.createMany({ data: billLineRows });
            }
            await tx.session_payment.update({
                where: { id: paymentId },
                data: { payment_status: 'paid', paid_at: now },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: sessionId,
                    event_type: 'payment_received',
                    payload_json: {
                        paymentId,
                        paymentMethod: payment.payment_method,
                        amountMinor: Number(payment.total_amount_minor),
                    },
                    actor_type: 'system',
                    occurred_at: now,
                },
            });
        });
    }
};
exports.PaymentsService = PaymentsService;
exports.PaymentsService = PaymentsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        sessions_service_1.SessionsService])
], PaymentsService);
//# sourceMappingURL=payments.service.js.map