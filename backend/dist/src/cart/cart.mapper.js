"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapCart = mapCart;
exports.mapCartItem = mapCartItem;
exports.asJsonObject = asJsonObject;
exports.toInputJson = toInputJson;
const customization_pricing_1 = require("../common/menu/customization-pricing");
function mapCart(row) {
    return {
        id: row.id,
        sessionId: row.session_id,
        version: row.version,
        updatedAt: row.updated_at.toISOString(),
        createdAt: row.created_at.toISOString(),
    };
}
function mapCartItem(row) {
    return {
        id: row.id,
        sessionCartId: row.session_cart_id,
        menuItemId: row.menu_item_id,
        quantity: row.quantity,
        selectionsJson: (row.selections_json ?? {}),
        unitPriceSnapshot: (0, customization_pricing_1.mapMoney)(row.unit_price_minor, row.currency_code),
        createdAt: row.created_at.toISOString(),
        updatedAt: row.updated_at.toISOString(),
    };
}
function asJsonObject(value) {
    if (value && typeof value === 'object' && !Array.isArray(value)) {
        return value;
    }
    return {};
}
function toInputJson(value) {
    return value;
}
//# sourceMappingURL=cart.mapper.js.map