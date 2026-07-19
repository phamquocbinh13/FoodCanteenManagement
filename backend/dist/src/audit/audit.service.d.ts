import { PrismaService } from '../prisma/prisma.service';
export declare class AuditService {
    private prisma;
    constructor(prisma: PrismaService);
    getRecentLogs(restaurantId: string): Promise<{
        id: string;
        action: string;
        entityType: string;
        entityId: string;
        occurredAt: Date;
        metadata: import("@prisma/client/runtime/library").JsonValue;
    }[]>;
}
