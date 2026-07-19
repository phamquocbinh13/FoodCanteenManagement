import { PrismaService } from '../prisma/prisma.service';
export declare class SettingsService {
    private prisma;
    constructor(prisma: PrismaService);
    getSettings(restaurantId: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        defaultCurrency: string;
        taxRateBps: number;
        serviceChargeBps: number;
        sessionTokenTtlMinutes: number;
        allowQrOnReservedTable: boolean;
        paymentSoftLockEnabled: boolean;
    }>;
    updateSettings(restaurantId: string, data: any): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        defaultCurrency: string;
        taxRateBps: number;
        serviceChargeBps: number;
        sessionTokenTtlMinutes: number;
        allowQrOnReservedTable: boolean;
        paymentSoftLockEnabled: boolean;
    }>;
}
