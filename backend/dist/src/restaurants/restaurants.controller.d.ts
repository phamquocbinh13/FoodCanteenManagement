import { PrismaService } from '../prisma/prisma.service';
export declare class RestaurantsController {
    private readonly prisma;
    constructor(prisma: PrismaService);
    findById(restaurantId: string): Promise<{
        settings: {
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
        } | null;
    } & {
        id: string;
        name: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        slug: string;
        timezone: string;
    }>;
    listTables(restaurantId: string): Promise<{
        items: {
            id: string;
            sortOrder: number;
            isActive: boolean;
            createdAt: Date;
            updatedAt: Date;
            restaurantId: string;
            status: string;
            label: string;
            capacity: number;
        }[];
    }>;
}
