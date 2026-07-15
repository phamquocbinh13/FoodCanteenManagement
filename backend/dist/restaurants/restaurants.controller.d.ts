import { PrismaService } from '../prisma/prisma.service';
export declare class RestaurantsController {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findById(restaurantId: string): Promise<{
        settings: {
            restaurantId: string;
            id: string;
            createdAt: Date;
            updatedAt: Date;
            defaultCurrency: string;
            taxRateBps: number;
            serviceChargeBps: number;
            sessionTokenTtlMinutes: number;
            allowQrOnReservedTable: boolean;
            paymentSoftLockEnabled: boolean;
        } | null;
    } & {
        id: string;
        slug: string;
        name: string;
        timezone: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
    }>;
    listTables(restaurantId: string): Promise<{
        items: {
            restaurantId: string;
            id: string;
            isActive: boolean;
            createdAt: Date;
            updatedAt: Date;
            label: string;
            capacity: number;
            status: string;
            sortOrder: number;
        }[];
    }>;
}
