import { type CustomerSessionContext } from '../sessions/guards/session-token.guard';
import { CreateStaffRequestDto } from './dto/requests.dto';
import { RequestsService } from './requests.service';
export declare class RequestsCustomerController {
    private readonly requests;
    constructor(requests: RequestsService);
    create(ctx: CustomerSessionContext, dto: CreateStaffRequestDto): Promise<import("./requests.mapper").StaffRequestDto>;
    list(ctx: CustomerSessionContext): Promise<{
        requests: import("./requests.mapper").StaffRequestDto[];
    }>;
}
