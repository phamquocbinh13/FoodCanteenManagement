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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VnpayController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_session_decorator_1 = require("../sessions/decorators/current-session.decorator");
const session_token_guard_1 = require("../sessions/guards/session-token.guard");
const payments_service_1 = require("./payments.service");
const vnpay_service_1 = require("./vnpay.service");
const prisma_service_1 = require("../prisma/prisma.service");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
let VnpayController = class VnpayController {
    vnpayService;
    paymentsService;
    prisma;
    constructor(vnpayService, paymentsService, prisma) {
        this.vnpayService = vnpayService;
        this.paymentsService = paymentsService;
        this.prisma = prisma;
    }
    async createPayment(ctx) {
        const { restaurantId, sessionId } = ctx;
        return await this.prisma.$transaction(async (tx) => {
            const session = await tx.dine_in_session.findFirst({
                where: { id: sessionId, restaurant_id: restaurantId },
            });
            if (!session || session.status === 'closed') {
                throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is already closed or not found');
            }
            const settings = await tx.restaurantSettings.findUnique({
                where: { restaurantId },
            });
            if (!settings)
                throw (0, api_exception_1.unprocessable)('SETTINGS_NOT_FOUND', 'Settings missing');
            const batchItems = await tx.batch_item.findMany({
                where: { kitchen_batch: { session_id: sessionId } },
            });
            let subtotalMinor = 0n;
            for (const item of batchItems)
                subtotalMinor += item.line_total_minor;
            const taxAmountMinor = (subtotalMinor * BigInt(settings.taxRateBps) + 5000n) / 10000n;
            const serviceChargeMinor = (subtotalMinor * BigInt(settings.serviceChargeBps) + 5000n) / 10000n;
            const totalAmountMinor = subtotalMinor + taxAmountMinor + serviceChargeMinor;
            if (totalAmountMinor <= 0n) {
                throw (0, api_exception_1.unprocessable)('ZERO_AMOUNT', 'Cannot pay zero amount');
            }
            let existingPayment = await tx.session_payment.findUnique({
                where: { session_id: sessionId },
            });
            if (existingPayment && existingPayment.payment_status === 'paid') {
                throw (0, api_exception_1.unprocessable)('SESSION_ALREADY_PAID', 'Session already paid');
            }
            const txnRef = (0, uuid_1.v4)();
            const now = new Date();
            const expiresAt = new Date(now.getTime() + 15 * 60 * 1000);
            if (!existingPayment) {
                await tx.session_payment.create({
                    data: {
                        id: txnRef,
                        session_id: sessionId,
                        payment_method: 'bank_transfer',
                        close_type: 'payment',
                        payment_status: 'waiting_gateway',
                        payment_provider: 'vnpay',
                        provider_transaction_id: txnRef,
                        subtotal_minor: subtotalMinor,
                        tax_amount_minor: taxAmountMinor,
                        service_charge_minor: serviceChargeMinor,
                        total_amount_minor: totalAmountMinor,
                        currency_code: settings.defaultCurrency,
                        closed_by_user_id: session.opened_by_user_id || null,
                        paid_at: now,
                        created_at: now,
                    },
                });
            }
            else {
                await tx.session_payment.update({
                    where: { session_id: sessionId },
                    data: {
                        payment_status: 'waiting_gateway',
                        payment_provider: 'vnpay',
                        provider_transaction_id: txnRef,
                        subtotal_minor: subtotalMinor,
                        tax_amount_minor: taxAmountMinor,
                        service_charge_minor: serviceChargeMinor,
                        total_amount_minor: totalAmountMinor,
                        paid_at: now,
                    },
                });
            }
            await tx.dine_in_session.update({
                where: { id: sessionId },
                data: { payment_status: 'waiting_payment', status: 'payment_pending' },
            });
            const orderInfo = `Pay ROMS Session ${sessionId.split('-')[0]}`;
            const url = this.vnpayService.createPaymentUrl('127.0.0.1', totalAmountMinor, txnRef, orderInfo);
            return { checkoutUrl: url };
        });
    }
    async getStatus(ctx) {
        const payment = await this.prisma.session_payment.findUnique({
            where: { session_id: ctx.sessionId },
            select: { payment_status: true },
        });
        return { status: payment?.payment_status || 'created' };
    }
    async ipn(query) {
        const { isValid, isSuccess, txnRef, amountMinor } = this.vnpayService.verifyIpn(query);
        if (!isValid) {
            return { RspCode: '97', Message: 'Invalid signature' };
        }
        const payment = await this.prisma.session_payment.findUnique({
            where: { id: txnRef },
        });
        if (!payment) {
            return { RspCode: '01', Message: 'Order not found' };
        }
        if (payment.total_amount_minor !== amountMinor) {
            return { RspCode: '04', Message: 'Invalid amount' };
        }
        if (payment.payment_status === 'paid') {
            return { RspCode: '02', Message: 'Order already confirmed' };
        }
        if (isSuccess) {
            await this.paymentsService.closeSessionOnWebhookSuccess(payment.session_id, payment.id);
            return { RspCode: '00', Message: 'Confirm Success' };
        }
        else {
            await this.prisma.$transaction([
                this.prisma.session_payment.update({
                    where: { id: txnRef },
                    data: { payment_status: 'failed' },
                }),
                this.prisma.dine_in_session.update({
                    where: { id: payment.session_id },
                    data: { payment_status: 'unpaid', status: 'open' },
                }),
            ]);
            return { RspCode: '00', Message: 'Confirm Success' };
        }
    }
};
exports.VnpayController = VnpayController;
__decorate([
    (0, common_1.Post)('sessions/me/payments/vnpay/create'),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], VnpayController.prototype, "createPayment", null);
__decorate([
    (0, common_1.Get)('sessions/me/payments/status'),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], VnpayController.prototype, "getStatus", null);
__decorate([
    (0, common_1.Get)('payments/vnpay/ipn'),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], VnpayController.prototype, "ipn", null);
exports.VnpayController = VnpayController = __decorate([
    (0, swagger_1.ApiTags)('vnpay'),
    (0, common_1.Controller)(),
    __metadata("design:paramtypes", [vnpay_service_1.VnpayService,
        payments_service_1.PaymentsService,
        prisma_service_1.PrismaService])
], VnpayController);
//# sourceMappingURL=vnpay.controller.js.map