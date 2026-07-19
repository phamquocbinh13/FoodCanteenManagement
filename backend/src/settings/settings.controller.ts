import { Controller, Get, Put, Body, Headers, UnauthorizedException } from '@nestjs/common';
import { SettingsService } from './settings.service';

@Controller('settings')
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  @Get()
  getSettings(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.settingsService.getSettings(restaurantId);
  }

  @Put()
  updateSettings(@Headers('x-restaurant-id') restaurantId: string, @Body() data: any) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.settingsService.updateSettings(restaurantId, data);
  }
}
