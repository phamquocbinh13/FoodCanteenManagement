import { PrismaService } from '../prisma/prisma.service';
export type KitchenQueueItemDto = {
    id: string;
    name: string;
    quantityLabel: string;
    kitchenNotes: string;
    status: string;
};
export type KitchenQueueBatchDto = {
    batchId: string;
    batchNumber: number;
    sessionDisplayNumber: string;
    tableLabel: string;
    createdAt: string;
    completedAt: string | null;
    status: 'pending' | 'completed';
    items: KitchenQueueItemDto[];
};
export declare class KitchenService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    getQueue(restaurantId: string): Promise<{
        batches: KitchenQueueBatchDto[];
        loadedAt: string;
    }>;
    completeBatchItem(restaurantId: string, batchItemId: string, changedByUserId: string): Promise<import("../batches/batches.mapper").BatchItemDto>;
}
