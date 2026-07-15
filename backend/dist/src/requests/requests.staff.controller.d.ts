import type { JwtPayload } from '../auth/auth.types';
import { HandleStaffRequestDto } from './dto/requests.dto';
import { RequestsService } from './requests.service';
export declare class RequestsStaffController {
    private readonly requests;
    constructor(requests: RequestsService);
    pending(restaurantId: string): Promise<{
        requests: import("./requests.mapper").StaffRequestDto[];
    }>;
    listSession(restaurantId: string, sessionId: string): Promise<{
        requests: import("./requests.mapper").StaffRequestDto[];
    }>;
    handle(restaurantId: string, requestId: string, user: JwtPayload, dto: HandleStaffRequestDto): Promise<import("./requests.mapper").StaffRequestDto>;
}
