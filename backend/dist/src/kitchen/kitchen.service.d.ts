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
}
