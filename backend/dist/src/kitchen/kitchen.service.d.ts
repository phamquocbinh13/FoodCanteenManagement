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
    completeBatchItem(restaurantId: string, batchItemId: string, changedByUserId: string): Promise<{
        ok: boolean;
    }>;
}
