import { AuditService } from './audit.service';
export declare class AuditController {
    private readonly auditService;
    constructor(auditService: AuditService);
    getRecentLogs(restaurantId: string): Promise<{
        id: string;
        action: string;
        entityType: string;
        entityId: string;
        occurredAt: Date;
        metadata: import("@prisma/client/runtime/library").JsonValue;
    }[]>;
}
