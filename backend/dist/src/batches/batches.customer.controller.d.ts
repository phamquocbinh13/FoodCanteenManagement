import { type CustomerSessionContext } from '../sessions/guards/session-token.guard';
import { BatchesService } from './batches.service';
import { ConfirmBatchDto } from './dto/batches.dto';
export declare class BatchesCustomerController {
    private readonly batches;
    constructor(batches: BatchesService);
    confirm(ctx: CustomerSessionContext, dto: ConfirmBatchDto): Promise<import("./batches.mapper").KitchenBatchTicketDto>;
    progress(ctx: CustomerSessionContext): Promise<{
        progress: import("./batches.mapper").BatchProgressDto[];
    }>;
}
