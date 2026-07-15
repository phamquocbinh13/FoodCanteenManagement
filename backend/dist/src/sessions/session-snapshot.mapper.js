"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapSessionSnapshot = mapSessionSnapshot;
const big_int_1 = require("../common/utils/big-int");
function mapSessionSnapshot(params) {
    const { session, activeToken, tableLabel } = params;
    return {
        session: {
            id: session.id,
            restaurantId: session.restaurant_id,
            tableId: session.table_id,
            sessionNumber: (0, big_int_1.toNumber)(session.session_number),
            displayNumber: session.display_number,
            status: session.status,
            openedVia: session.opened_via,
            openedByUserId: session.opened_by_user_id,
            closedByUserId: session.closed_by_user_id,
            paymentSoftLock: session.payment_soft_lock,
            currentBatchNumber: session.current_batch_number,
            paymentStatus: session.payment_status,
            paymentSummary: {
                subtotalMinor: (0, big_int_1.toNumber)(session.payment_subtotal_minor),
                discountMinor: (0, big_int_1.toNumber)(session.payment_discount_minor),
                taxMinor: (0, big_int_1.toNumber)(session.payment_tax_minor),
                serviceChargeMinor: (0, big_int_1.toNumber)(session.payment_service_charge_minor),
                totalMinor: (0, big_int_1.toNumber)(session.payment_total_minor),
            },
            openedAt: session.opened_at.toISOString(),
            closedAt: session.closed_at?.toISOString() ?? null,
            createdAt: session.created_at.toISOString(),
            updatedAt: session.updated_at.toISOString(),
        },
        activeToken: activeToken
            ? {
                id: activeToken.id,
                sessionId: activeToken.session_id,
                tokenHash: activeToken.token_hash,
                expiresAt: activeToken.expires_at.toISOString(),
                revokedAt: activeToken.revoked_at?.toISOString() ?? null,
                createdAt: activeToken.created_at.toISOString(),
            }
            : null,
        tableLabel,
        batchIds: params.batchIds ?? [],
        requestIds: params.requestIds ?? [],
    };
}
//# sourceMappingURL=session-snapshot.mapper.js.map