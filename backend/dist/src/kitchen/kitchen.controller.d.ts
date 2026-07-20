import type { JwtPayload } from '../auth/auth.types';
import { KitchenService } from './kitchen.service';
export declare class KitchenController {
    private readonly kitchen;
    constructor(kitchen: KitchenService);
    queue(restaurantId: string): Promise<{
        batches: import("./kitchen.service").KitchenQueueBatchDto[];
        loadedAt: string;
    }>;
    overview(restaurantId: string): Promise<{
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
    workflow(restaurantId: string): Promise<{
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
    complete(restaurantId: string, batchItemId: string, user: JwtPayload): Promise<{
        ok: boolean;
    }>;
}
