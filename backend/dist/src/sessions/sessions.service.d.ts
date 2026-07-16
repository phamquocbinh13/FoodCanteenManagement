import { PrismaService } from '../prisma/prisma.service';
import { AppendTimelineDto, CreateSessionDto, UpdateSessionDto } from './dto/sessions.dto';
import { SessionSnapshot } from './session-snapshot.mapper';
export declare class SessionsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(restaurantId: string, openedByUserId: string, dto: CreateSessionDto): Promise<{
        snapshot: SessionSnapshot;
        sessionToken: string;
    }>;
    join(sessionToken: string, deviceId?: string): Promise<SessionSnapshot>;
    me(sessionToken: string): Promise<SessionSnapshot>;
    findById(restaurantId: string, sessionId: string): Promise<SessionSnapshot>;
    reissueToken(restaurantId: string, sessionId: string): Promise<{
        sessionToken: string;
        expiresAt: string;
        snapshot: SessionSnapshot;
    }>;
    listActive(restaurantId: string): Promise<{
        items: SessionSnapshot[];
    }>;
    findActiveByTable(restaurantId: string, tableId: string): Promise<{
        session: SessionSnapshot | null;
    }>;
    markWaitingPayment(restaurantId: string, sessionId: string): Promise<SessionSnapshot>;
    close(restaurantId: string, sessionId: string, closedByUserId: string): Promise<SessionSnapshot>;
    transfer(): never;
    nextDailySequence(restaurantId: string, dateKey: string): Promise<{
        nextSequence: number;
    }>;
    update(restaurantId: string, sessionId: string, dto: UpdateSessionDto): Promise<SessionSnapshot>;
    appendTimeline(restaurantId: string, sessionId: string, dto: AppendTimelineDto, actorUserId?: string): Promise<{
        id: string;
    }>;
    getBill(restaurantId: string, sessionId: string): Promise<{
        sessionId: string;
        paymentStatus: string;
        paymentSummary: {
            subtotalMinor: number;
            discountMinor: number;
            taxMinor: number;
            serviceChargeMinor: number;
            totalMinor: number;
        };
    }>;
    nextBatchNumber(restaurantId: string, sessionId: string): Promise<{
        nextBatchNumber: number;
    }>;
    private allocateDailySequence;
    private resolveByToken;
    private requireSession;
    private getSnapshotById;
    private calculateBalance;
}
