import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { AuditService } from './audit.service';

@ApiTags('audit')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId/audit')
export class AuditController {
  constructor(private readonly auditService: AuditService) {}

  @Get('recent')
  async getRecentLogs(@Param('restaurantId') restaurantId: string) {
    return this.auditService.getRecentLogs(restaurantId);
  }
}
