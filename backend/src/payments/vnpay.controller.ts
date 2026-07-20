import { Controller, Get, Post, Query, UseGuards, Res, Req } from '@nestjs/common';
import type { Request, Response } from 'express';
import { ApiHeader, ApiTags } from '@nestjs/swagger';
import { CurrentSession } from '../sessions/decorators/current-session.decorator';
import { SessionTokenGuard, type CustomerSessionContext } from '../sessions/guards/session-token.guard';
import { PaymentsService } from './payments.service';
import { VnpayService } from './vnpay.service';
import { PrismaService } from '../prisma/prisma.service';
import { v4 as uuidv4 } from 'uuid';
import { unprocessable } from '../common/errors/api-exception';

@ApiTags('vnpay')
@Controller()
export class VnpayController {
  constructor(
    private readonly vnpayService: VnpayService,
    private readonly paymentsService: PaymentsService,
    private readonly prisma: PrismaService,
  ) {}

  @Post('sessions/me/payments/vnpay/create')
  @UseGuards(SessionTokenGuard)
  @ApiHeader({ name: 'X-Session-Token', required: false })
  async createPayment(
    @CurrentSession() ctx: CustomerSessionContext,
    @Req() req: Request,
  ) {
    const { restaurantId, sessionId } = ctx;
    const host = req.headers.host || 'localhost:3000';
    const customReturnUrl = `http://${host}/api/v1/payments/vnpay/return`;
    
    return await this.prisma.$transaction(async (tx) => {
      // 1. Validate session
      const session = await tx.dine_in_session.findFirst({
        where: { id: sessionId, restaurant_id: restaurantId },
      });
      if (!session || session.status === 'closed') {
        throw unprocessable('SESSION_CLOSED', 'Session is already closed or not found');
      }

      // 2. Compute Bill
      const settings = await tx.restaurantSettings.findUnique({
        where: { restaurantId },
      });
      if (!settings) throw unprocessable('SETTINGS_NOT_FOUND', 'Settings missing');

      const balance = await this.paymentsService.calculateSessionBalance(sessionId);
      if (balance.outstandingMinor <= 0n) {
        throw unprocessable('ZERO_AMOUNT', 'Cannot pay zero amount, bill is already settled.');
      }

      const totalAmountMinor = balance.outstandingMinor;

      // 3. Create or update pending session_payment (we always create a new one now for split bills, or update if there's a pending one)
      let existingPayment = await tx.session_payment.findFirst({
        where: { session_id: sessionId, payment_status: 'waiting_gateway' },
      });

      const txnRef = uuidv4();
      const now = new Date();
      // expire in 15 mins
      const expiresAt = new Date(now.getTime() + 15 * 60 * 1000);

      if (!existingPayment) {
        await tx.session_payment.create({
          data: {
            id: txnRef, // Use ID as txnRef
            session_id: sessionId,
            payment_method: 'bank_transfer',
            close_type: 'payment',
            payment_status: 'waiting_gateway',
            payment_provider: 'vnpay',
            provider_transaction_id: txnRef,
            subtotal_minor: totalAmountMinor, // Map remaining entirely to subtotal for now as partial payment
            tax_amount_minor: 0n,
            service_charge_minor: 0n,
            total_amount_minor: totalAmountMinor,
            currency_code: settings.defaultCurrency,
            closed_by_user_id: session.opened_by_user_id || null,
            paid_at: now,
            created_at: now,
          },
        });
      } else {
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

  @Get('sessions/me/payments/status')
  @UseGuards(SessionTokenGuard)
  @ApiHeader({ name: 'X-Session-Token', required: false })
  async getStatus(@CurrentSession() ctx: CustomerSessionContext) {
    const payment = await this.prisma.session_payment.findFirst({
      where: { session_id: ctx.sessionId },
      select: { payment_status: true },
      orderBy: { created_at: 'desc' },
    });
    return { status: payment?.payment_status || 'created' };
  }

  @Get('payments/vnpay/ipn')
  async ipn(@Query() query: any) {
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
      // Confirm payment
      await this.paymentsService.confirmPaymentOnWebhookSuccess(payment.session_id, payment.id);
      return { RspCode: '00', Message: 'Confirm Success' };
    } else {
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

  @Get('payments/vnpay/return')
  async vnpayReturn(@Query() query: any, @Res() res: Response) {
    const { isValid, isSuccess, amountMinor, txnRef } = this.vnpayService.verifyIpn(query);

    let statusHtml = '';
    if (!isValid) {
      statusHtml = '<h2 style="color: red;">Invalid Signature</h2><p>The payment response is invalid.</p>';
    } else {
      const payment = await this.prisma.session_payment.findFirst({
        where: { provider_transaction_id: txnRef },
      });

      if (payment && payment.payment_status !== 'paid') {
        if (isSuccess) {
          await this.paymentsService.confirmPaymentOnWebhookSuccess(payment.session_id, payment.id);
        } else {
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
      } else {
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
}
