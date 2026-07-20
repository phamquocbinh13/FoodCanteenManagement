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
    async createPayment(ctx, req) {
        const { restaurantId, sessionId } = ctx;
        const host = req.headers.host || 'localhost:3000';
        const customReturnUrl = `http://${host}/api/v1/payments/vnpay/return`;
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
            const balance = await this.paymentsService.calculateSessionBalance(sessionId);
            if (balance.outstandingMinor <= 0n) {
                throw (0, api_exception_1.unprocessable)('ZERO_AMOUNT', 'Cannot pay zero amount, bill is already settled.');
            }
            const totalAmountMinor = balance.outstandingMinor;
            let existingPayment = await tx.session_payment.findFirst({
                where: { session_id: sessionId, payment_status: 'waiting_gateway' },
            });
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
                        subtotal_minor: totalAmountMinor,
                        tax_amount_minor: 0n,
                        service_charge_minor: 0n,
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
                    where: { id: existingPayment.id },
                    data: {
                        payment_status: 'waiting_gateway',
                        payment_provider: 'vnpay',
                        provider_transaction_id: txnRef,
                        subtotal_minor: totalAmountMinor,
                        tax_amount_minor: 0n,
                        service_charge_minor: 0n,
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
            const url = this.vnpayService.createPaymentUrl('127.0.0.1', totalAmountMinor, txnRef, orderInfo, customReturnUrl);
            return { checkoutUrl: url };
        });
    }
    async getStatus(ctx) {
        const payment = await this.prisma.session_payment.findFirst({
            where: { session_id: ctx.sessionId },
            select: { payment_status: true },
            orderBy: { created_at: 'desc' },
        });
        return { status: payment?.payment_status || 'created' };
    }
    async ipn(query) {
        const { isValid, isSuccess, txnRef, amountMinor } = this.vnpayService.verifyIpn(query);
        if (!isValid) {
            return { RspCode: '97', Message: 'Invalid signature' };
        }
        const payment = await this.prisma.session_payment.findFirst({
            where: { provider_transaction_id: txnRef },
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
            await this.paymentsService.confirmPaymentOnWebhookSuccess(payment.session_id, payment.id);
            return { RspCode: '00', Message: 'Confirm Success' };
        }
        else {
            await this.prisma.$transaction([
                this.prisma.session_payment.update({
                    where: { id: payment.id },
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
    async vnpayReturn(query, res) {
        const { isValid, isSuccess, amountMinor, txnRef } = this.vnpayService.verifyIpn(query);
        let statusHtml = '';
        if (!isValid) {
            statusHtml = '<h2 style="color: red;">Invalid Signature</h2><p>The payment response is invalid.</p>';
        }
        else {
            const payment = await this.prisma.session_payment.findFirst({
                where: { provider_transaction_id: txnRef },
            });
            if (payment && payment.payment_status !== 'paid') {
                if (isSuccess) {
                    await this.paymentsService.confirmPaymentOnWebhookSuccess(payment.session_id, payment.id);
                }
                else {
                    await this.prisma.$transaction([
                        this.prisma.session_payment.update({
                            where: { id: payment.id },
                            data: { payment_status: 'failed' },
                        }),
                        this.prisma.dine_in_session.update({
                            where: { id: payment.session_id },
                            data: { payment_status: 'unpaid', status: 'open' },
                        }),
                    ]);
                }
            }
            if (isSuccess) {
                statusHtml = `<h2 style="color: green;">Payment Successful</h2><p>You have successfully paid ${amountMinor} VND.</p>`;
            }
            else {
                statusHtml = '<h2 style="color: orange;">Payment Failed / Canceled</h2><p>The payment was not completed.</p>';
            }
        }
        const redirectUrl = isSuccess ? 'roms://payment-success' : 'roms://payment-failure';
        const html = `
      <!DOCTYPE html>
      <html>
      <head>
        <title>ROMS Payment Status</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
          body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; margin: 0; background-color: #f4f4f9; }
          .card { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; max-width: 400px; width: 90%; }
          .btn { display: inline-block; margin-top: 1.5rem; padding: 0.75rem 1.5rem; background: #000; color: #fff; text-decoration: none; border-radius: 4px; font-size: 1rem; font-weight: bold; cursor: pointer; border: none; }
        </style>
      </head>
      <body>
        <div class="card">
          ${statusHtml}
          <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
            <a href="${redirectUrl}" class="btn">Return to App</a>
            <button onclick="window.close()" class="btn" style="background: #555;">Close Tab</button>
          </div>
          <p style="margin-top: 1rem; color: #666; font-size: 0.9rem;">Please return to the ROMS App to view your updated session status.</p>
        </div>
        <script>
          setTimeout(function() {
            window.location.href = "${redirectUrl}";
            setTimeout(function() {
              try {
                window.close();
              } catch (e) {}
            }, 1000);
          }, 1000);
        </script>
      </body>
      </html>
    `;
        return res.status(200).send(html);
    }
};
exports.VnpayController = VnpayController;
__decorate([
    (0, common_1.Post)('sessions/me/payments/vnpay/create'),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
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
__decorate([
    (0, common_1.Get)('payments/vnpay/return'),
    __param(0, (0, common_1.Query)()),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], VnpayController.prototype, "vnpayReturn", null);
exports.VnpayController = VnpayController = __decorate([
    (0, swagger_1.ApiTags)('vnpay'),
    (0, common_1.Controller)(),
    __metadata("design:paramtypes", [vnpay_service_1.VnpayService,
        payments_service_1.PaymentsService,
        prisma_service_1.PrismaService])
], VnpayController);
//# sourceMappingURL=vnpay.controller.js.map