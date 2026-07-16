import { PrismaService } from '../prisma/prisma.service';
import { SessionsService } from '../sessions/sessions.service';
import type { SessionSnapshot } from '../sessions/session-snapshot.mapper';
import { CreateSessionPaymentDto } from './dto/create-session-payment.dto';
import { type SessionBillLineDto, type SessionPaymentDto } from './payments.mapper';
export type CreatePaymentResult = {
    payment: SessionPaymentDto;
    billLines: SessionBillLineDto[];
    snapshot: SessionSnapshot;
};
export declare class PaymentsService {
    private readonly prisma;
    private readonly sessions;
    constructor(prisma: PrismaService, sessions: SessionsService);
    create(restaurantId: string, sessionId: string, closedByUserId: string, dto: CreateSessionPaymentDto): Promise<CreatePaymentResult>;
    closeSessionOnWebhookSuccess(sessionId: string, paymentId: string): Promise<void>;
}
