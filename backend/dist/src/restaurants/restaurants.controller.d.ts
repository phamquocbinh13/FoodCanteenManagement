import { PrismaService } from '../prisma/prisma.service';
export declare class RestaurantsController {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findById(restaurantId: string): Promise<{
        settings: {
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
        } | null;
    } & {
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        name: string;
        slug: string;
        timezone: string;
    }>;
    listTables(restaurantId: string): Promise<{
        items: {
            id: string;
            restaurantId: string;
            isActive: boolean;
            createdAt: Date;
            updatedAt: Date;
            sortOrder: number;
            status: string;
            label: string;
            capacity: number;
        }[];
    }>;
}
