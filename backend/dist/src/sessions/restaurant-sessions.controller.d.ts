import type { JwtPayload } from '../auth/auth.types';
import { AppendTimelineDto, CloseSessionDto, CreateSessionDto, TransferSessionDto, UpdateSessionDto } from './dto/sessions.dto';
import { SessionsService } from './sessions.service';
export declare class RestaurantSessionsController {
    private readonly sessions;
    constructor(sessions: SessionsService);
    create(restaurantId: string, user: JwtPayload, dto: CreateSessionDto): Promise<{
        snapshot: import("./session-snapshot.mapper").SessionSnapshot;
        sessionToken: string;
    }>;
    listActive(restaurantId: string): Promise<{
        items: import("./session-snapshot.mapper").SessionSnapshot[];
    }>;
    nextDailySequence(restaurantId: string, dateKey: string): Promise<{
        nextSequence: number;
    }>;
    findById(restaurantId: string, sessionId: string): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
    findByTable(restaurantId: string, tableId: string): Promise<{
        session: import("./session-snapshot.mapper").SessionSnapshot | null;
    }>;
    waitingPayment(restaurantId: string, sessionId: string): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
    close(restaurantId: string, sessionId: string, user: JwtPayload, dto: CloseSessionDto): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
    transfer(_restaurantId: string, _sessionId: string, _dto: TransferSessionDto): never;
    update(restaurantId: string, sessionId: string, dto: UpdateSessionDto): Promise<import("./session-snapshot.mapper").SessionSnapshot>;
    appendTimeline(restaurantId: string, sessionId: string, user: JwtPayload, dto: AppendTimelineDto): Promise<{
        id: string;
    }>;
    nextBatchNumber(restaurantId: string, sessionId: string): Promise<{
        nextBatchNumber: number;
    }>;
    bill(restaurantId: string, sessionId: string): Promise<{
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
}
