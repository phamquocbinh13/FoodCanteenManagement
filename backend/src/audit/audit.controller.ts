import { Controller, Get, Headers, UnauthorizedException } from '@nestjs/common';
import { AuditService } from './audit.service';

@Controller('audit')
export class AuditController {
  constructor(private readonly auditService: AuditService) {}

  @Get('recent')
  async getRecentLogs(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException('Missing restaurant ID');
    return this.auditService.getRecentLogs(restaurantId);
  }
}
