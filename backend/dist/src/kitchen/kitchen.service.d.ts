import { type KitchenBatchTicketDto } from '../batches/batches.mapper';
import { PrismaService } from '../prisma/prisma.service';
export type KitchenQueueBatchDto = KitchenBatchTicketDto & {
    sessionDisplayNumber: string;
    status: 'pending' | 'completed';
};
export declare class KitchenService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    getQueue(restaurantId: string): Promise<{
        batches: KitchenQueueBatchDto[];
        loadedAt: string;
    }>;
    getOverview(restaurantId: string): Promise<{
        totalActiveOrders: number;
        totalFoodOrders: number;
        totalDrinkOrders: number;
        averageWaitingMinutes: number;
        longestWaitingTable: string | null;
        longestWaitingMinutes: number;
        ordersReady: number;
        ordersPreparing: number;
        ordersWaiting: number;
        menuDemand: Array<{
            menuItemId: string;
            name: string;
            quantity: number;
        }>;
    }>;
    completeBatchItem(restaurantId: string, batchItemId: string, changedByUserId: string): Promise<{
        ok: boolean;
    }>;
    getWorkflow(restaurantId: string): Promise<{
        buckets: {
            URGENT: {
                menuItemId: string;
                name: string;
                quantity: number;
                oldestWaitingMinutes: number;
                batchCount: number;
            }[];
            HIGH: {
                menuItemId: string;
                name: string;
                quantity: number;
                oldestWaitingMinutes: number;
                batchCount: number;
            }[];
            NORMAL: {
                menuItemId: string;
                name: string;
                quantity: number;
                oldestWaitingMinutes: number;
                batchCount: number;
            }[];
            NEW: {
                menuItemId: string;
                name: string;
                quantity: number;
                oldestWaitingMinutes: number;
                batchCount: number;
            }[];
        };
        preparationSummary: {
            group: string;
            options: {
                name: string;
                quantity: number;
            }[];
        }[];
        stats: {
            oldestTicketMinutes: number;
            mostOrderedItem: string;
            totalFoodQty: number;
            averageWaitingTimeMinutes: number;
        };
    }>;
}
