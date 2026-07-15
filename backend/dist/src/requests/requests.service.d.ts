import { PrismaService } from '../prisma/prisma.service';
import { CreateStaffRequestDto, HandleStaffRequestDto } from './dto/requests.dto';
import { type StaffRequestDto } from './requests.mapper';
export declare class RequestsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(restaurantId: string, sessionId: string, dto: CreateStaffRequestDto): Promise<StaffRequestDto>;
    listForSession(restaurantId: string, sessionId: string): Promise<{
        requests: StaffRequestDto[];
    }>;
    listPending(restaurantId: string): Promise<{
        requests: StaffRequestDto[];
    }>;
    handle(restaurantId: string, requestId: string, dto: HandleStaffRequestDto, actorUserId: string): Promise<StaffRequestDto>;
    private requireSession;
    private requireOpenSession;
}
