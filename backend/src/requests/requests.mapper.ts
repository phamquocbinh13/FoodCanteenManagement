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

export function mapStaffRequest(row: staff_request): StaffRequestDto {
  return {
    id: row.id,
    restaurantId: row.restaurant_id,
    sessionId: row.session_id,
    requestType: row.request_type,
    status: row.status,
    note: row.note,
    requestedAt: row.requested_at.toISOString(),
    handledAt: row.handled_at?.toISOString() ?? null,
    handledByUserId: row.handled_by_user_id,
    createdAt: row.created_at.toISOString(),
  };
}
