import { staff_request } from '@prisma/client';
export type StaffRequestDto = {
    id: string;
    restaurantId: string;
    sessionId: string;
    requestType: string;
    status: string;
    note: string | null;
    requestedAt: string;
    handledAt: string | null;
    handledByUserId: string | null;
    createdAt: string;
};
export declare function mapStaffRequest(row: staff_request): StaffRequestDto;
