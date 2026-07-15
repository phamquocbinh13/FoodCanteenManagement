import { BatchesService } from './batches.service';
import { BulkCustomizationsDto, ConfirmBatchDto, CreateBatchDto, CreateBatchItemDto, UpdateBatchItemQuantityDto } from './dto/batches.dto';
export declare class BatchesStaffController {
    private readonly batches;
    constructor(batches: BatchesService);
    confirm(restaurantId: string, sessionId: string, dto: ConfirmBatchDto): Promise<import("./batches.mapper").KitchenBatchTicketDto>;
    listSession(restaurantId: string, sessionId: string): Promise<{
        batches: import("./batches.mapper").KitchenBatchTicketDto[];
    }>;
    createBatch(restaurantId: string, sessionId: string, dto: CreateBatchDto): Promise<import("./batches.mapper").KitchenBatchDto>;
    createItem(restaurantId: string, batchId: string, dto: CreateBatchItemDto): Promise<import("./batches.mapper").BatchItemDto>;
    createCustomizations(restaurantId: string, batchItemId: string, dto: BulkCustomizationsDto): Promise<{
        count: number;
    }>;
    getBatch(restaurantId: string, batchId: string): Promise<import("./batches.mapper").KitchenBatchTicketDto>;
    updateItemQuantity(restaurantId: string, batchItemId: string, dto: UpdateBatchItemQuantityDto): Promise<void>;
    deleteItem(restaurantId: string, batchItemId: string): Promise<void>;
}
