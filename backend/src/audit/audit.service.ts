import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuditService {
  constructor(private prisma: PrismaService) {}

  async getRecentLogs(restaurantId: string) {
    const logs = await this.prisma.audit_log.findMany({
      where: { restaurant_id: restaurantId },
      orderBy: { occurred_at: 'desc' },
      take: 10,
    });
    
    return logs.map(log => ({
      id: log.id,
      action: log.action,
      entityType: log.entity_type,
      entityId: log.entity_id,
      occurredAt: log.occurred_at,
      metadata: log.metadata_json,
    }));
  }
}
