import { PrismaService } from '../prisma/prisma.service';
import { type BatchProgressDto, type KitchenBatchTicketDto, type KitchenBatchDto, type BatchItemDto } from './batches.mapper';
import { BulkCustomizationsDto, ConfirmBatchDto, CreateBatchDto, CreateBatchItemDto } from './dto/batches.dto';
export declare class BatchesService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    confirmFromCart(restaurantId: string, sessionId: string, dto?: ConfirmBatchDto): Promise<KitchenBatchTicketDto>;
    getProgress(restaurantId: string, sessionId: string): Promise<{
        progress: BatchProgressDto[];
    }>;
    listSessionBatches(restaurantId: string, sessionId: string): Promise<{
        batches: KitchenBatchTicketDto[];
    }>;
    createBatch(restaurantId: string, sessionId: string, dto: CreateBatchDto): Promise<KitchenBatchDto>;
    createBatchItem(restaurantId: string, batchId: string, dto: CreateBatchItemDto): Promise<BatchItemDto>;
    createCustomizations(restaurantId: string, batchItemId: string, dto: BulkCustomizationsDto): Promise<{
        count: number;
    }>;
    getBatch(restaurantId: string, batchId: string): Promise<KitchenBatchTicketDto>;
    private requireSession;
    private requireOpenSession;
}
