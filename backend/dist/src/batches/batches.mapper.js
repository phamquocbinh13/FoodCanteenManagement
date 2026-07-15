"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapBatch = mapBatch;
exports.mapBatchItem = mapBatchItem;
exports.lineTotalMinor = lineTotalMinor;
exports.toNum = toNum;
const customization_pricing_1 = require("../common/menu/customization-pricing");
const big_int_1 = require("../common/utils/big-int");
function mapBatch(row) {
    return {
        id: row.id,
        restaurantId: row.restaurant_id,
        sessionId: row.session_id,
        orderId: row.order_id,
        batchNumber: row.batch_number,
        confirmedAt: row.confirmed_at.toISOString(),
        confirmedByActorType: row.confirmed_by_actor_type,
        confirmedByActorId: row.confirmed_by_actor_id,
        completedAt: row.completed_at?.toISOString() ?? null,
        createdAt: row.created_at.toISOString(),
    };
}
function mapBatchItem(row) {
    return {
        id: row.id,
        batchId: row.batch_id,
        menuItemId: row.menu_item_id,
        menuItemNameSnapshot: row.menu_item_name_snapshot,
        unitPriceSnapshot: (0, customization_pricing_1.mapMoney)(row.unit_price_minor, row.currency_code),
        quantity: row.quantity,
        lineTotal: (0, customization_pricing_1.mapMoney)(row.line_total_minor, row.currency_code),
        kitchenNotesRendered: row.kitchen_notes_rendered,
        status: row.status,
        statusUpdatedAt: row.status_updated_at.toISOString(),
        createdAt: row.created_at.toISOString(),
    };
}
function lineTotalMinor(unit, qty) {
    return unit * BigInt(qty);
}
function toNum(v) {
    return (0, big_int_1.toNumber)(v);
}
//# sourceMappingURL=batches.mapper.js.map