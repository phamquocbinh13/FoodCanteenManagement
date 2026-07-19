import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SettingsService {
  constructor(private prisma: PrismaService) {}

  async getSettings(restaurantId: string) {
    const settings = await this.prisma.restaurantSettings.findUnique({
      where: { restaurantId }
    });
    if (!settings) throw new NotFoundException('Settings not found');
    return settings;
  }

  async updateSettings(restaurantId: string, data: any) {
    return this.prisma.restaurantSettings.update({
      where: { restaurantId },
      data: {
        defaultCurrency: data.defaultCurrency,
        taxRateBps: data.taxRateBps,
        serviceChargeBps: data.serviceChargeBps,
        sessionTokenTtlMinutes: data.sessionTokenTtlMinutes,
        allowQrOnReservedTable: data.allowQrOnReservedTable,
        paymentSoftLockEnabled: data.paymentSoftLockEnabled,
      }
    });
  }
}
