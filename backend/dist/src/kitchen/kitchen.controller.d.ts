import type { JwtPayload } from '../auth/auth.types';
import { KitchenService } from './kitchen.service';
export declare class KitchenController {
    private readonly kitchen;
    constructor(kitchen: KitchenService);
    queue(restaurantId: string): Promise<{
        batches: import("./kitchen.service").KitchenQueueBatchDto[];
        loadedAt: string;
    }>;
    complete(restaurantId: string, batchItemId: string, user: JwtPayload): Promise<import("../batches/batches.mapper").BatchItemDto>;
}
