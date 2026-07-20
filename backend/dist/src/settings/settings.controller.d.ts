import { SettingsService } from './settings.service';
export declare class SettingsController {
    private readonly settingsService;
    constructor(settingsService: SettingsService);
    getSettings(restaurantId: string): Promise<{
        id: string;
        restaurantId: string;
        createdAt: Date;
        updatedAt: Date;
        defaultCurrency: string;
        taxRateBps: number;
        serviceChargeBps: number;
        sessionTokenTtlMinutes: number;
        allowQrOnReservedTable: boolean;
        paymentSoftLockEnabled: boolean;
    }>;
    updateSettings(restaurantId: string, data: any): Promise<{
        id: string;
        restaurantId: string;
        createdAt: Date;
        updatedAt: Date;
        defaultCurrency: string;
        taxRateBps: number;
        serviceChargeBps: number;
        sessionTokenTtlMinutes: number;
        allowQrOnReservedTable: boolean;
        paymentSoftLockEnabled: boolean;
    }>;
}
