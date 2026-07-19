import { PrismaService } from '../prisma/prisma.service';
export declare class AnalyticsService {
    private prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    getVelocity(restaurantId: string): Promise<{
        best_sellers: {
            id: string | undefined;
            name: string | undefined;
            image_url: string | null | undefined;
            quantity_sold: number;
            currency_code: string | undefined;
            base_price_minor: number;
        }[];
        worst_sellers: {
            id: string | undefined;
            name: string | undefined;
            image_url: string | null | undefined;
            quantity_sold: number;
            currency_code: string | undefined;
            base_price_minor: number;
        }[];
    }>;
    getInsights(): Promise<{
        alerts: string[];
        forecast_days: {
            date: any;
            weather_code: any;
            temp_max: number;
            temp_min: number;
        }[];
    }>;
    getRevenue(restaurantId: string): Promise<{
        date: string;
        revenue_minor: number;
    }[]>;
    getHeatmap(restaurantId: string): Promise<{
        hour: number;
        intensity: number;
    }[]>;
    getKpis(restaurantId: string): Promise<{
        average_order_value_minor: number;
        total_sessions: number;
        total_revenue_minor: number;
        payment_methods: {
            method: string;
            total_minor: number;
        }[];
    }>;
}
