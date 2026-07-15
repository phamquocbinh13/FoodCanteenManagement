"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapStaffRequest = mapStaffRequest;
function mapStaffRequest(row) {
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
//# sourceMappingURL=requests.mapper.js.map