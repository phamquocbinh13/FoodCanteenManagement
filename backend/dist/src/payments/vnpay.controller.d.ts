import type { Response } from 'express';
import { type CustomerSessionContext } from '../sessions/guards/session-token.guard';
import { PaymentsService } from './payments.service';
import { VnpayService } from './vnpay.service';
import { PrismaService } from '../prisma/prisma.service';
export declare class VnpayController {
    private readonly vnpayService;
    private readonly paymentsService;
    private readonly prisma;
    constructor(vnpayService: VnpayService, paymentsService: PaymentsService, prisma: PrismaService);
    createPayment(ctx: CustomerSessionContext): Promise<{
        checkoutUrl: string;
    }>;
    getStatus(ctx: CustomerSessionContext): Promise<{
        status: string;
    }>;
    ipn(query: any): Promise<{
        RspCode: string;
        Message: string;
    }>;
    vnpayReturn(query: any, res: Response): Promise<Response<any, Record<string, any>>>;
}
