import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { AnalyticsService } from './analytics.service';

@ApiTags('analytics')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId/analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('velocity')
  async getVelocity(@Param('restaurantId') restaurantId: string) {
    return this.analyticsService.getVelocity(restaurantId);
  }

  @Get('insights')
  async getInsights() {
    return this.analyticsService.getInsights();
  }

  @Get('revenue')
  async getRevenue(@Param('restaurantId') restaurantId: string) {
    return this.analyticsService.getRevenue(restaurantId);
  }

  @Get('heatmap')
  async getHeatmap(@Param('restaurantId') restaurantId: string) {
    return this.analyticsService.getHeatmap(restaurantId);
  }

  @Get('kpis')
  async getKpis(@Param('restaurantId') restaurantId: string) {
    return this.analyticsService.getKpis(restaurantId);
  }
}
