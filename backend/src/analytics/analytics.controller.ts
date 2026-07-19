import { Controller, Get, Param, Headers, UnauthorizedException } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('velocity')
  async getVelocity(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException('Missing restaurant ID');
    return this.analyticsService.getVelocity(restaurantId);
  }

  @Get('insights')
  async getInsights() {
    return this.analyticsService.getInsights();
  }

  @Get('revenue')
  async getRevenue(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException('Missing restaurant ID');
    return this.analyticsService.getRevenue(restaurantId);
  }

  @Get('heatmap')
  async getHeatmap(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException('Missing restaurant ID');
    return this.analyticsService.getHeatmap(restaurantId);
  }

  @Get('kpis')
  async getKpis(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException('Missing restaurant ID');
    return this.analyticsService.getKpis(restaurantId);
  }
}
