import { PrismaService } from '../prisma/prisma.service';
export declare class AnalyticsService {
    private prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    getVelocity(restaurantId: string): Promise<{
        bestSellers: {
            id: string | undefined;
            name: string | undefined;
            imageUrl: string | null | undefined;
            quantitySold: number;
            currencyCode: string | undefined;
            basePriceMinor: number;
        }[];
        worstSellers: {
            id: string | undefined;
            name: string | undefined;
            imageUrl: string | null | undefined;
            quantitySold: number;
            currencyCode: string | undefined;
            basePriceMinor: number;
        }[];
    }>;
    getInsights(): Promise<{
        alerts: string[];
    }>;
    getRevenue(restaurantId: string): Promise<{
        date: string;
        revenueMinor: number;
    }[]>;
    getHeatmap(restaurantId: string): Promise<{
        hour: number;
        intensity: number;
    }[]>;
    getKpis(restaurantId: string): Promise<{
        averageOrderValueMinor: number;
        totalSessions: number;
        totalRevenueMinor: number;
        paymentMethods: {
            method: string;
            totalMinor: number;
        }[];
    }>;
}
