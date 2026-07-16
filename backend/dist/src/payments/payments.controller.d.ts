import type { JwtPayload } from '../auth/auth.types';
import { CreateSessionPaymentDto } from './dto/create-session-payment.dto';
import { PaymentsService } from './payments.service';
export declare class PaymentsController {
    private readonly payments;
    constructor(payments: PaymentsService);
    create(restaurantId: string, sessionId: string, user: JwtPayload, dto: CreateSessionPaymentDto, _idempotencyKey?: string): Promise<import("./payments.service").CreatePaymentResult>;
    balance(sessionId: string): Promise<{
        totalMinor: bigint;
        paidMinor: bigint;
        outstandingMinor: bigint;
    }>;
}
