"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapCategory = mapCategory;
exports.mapMenuItem = mapMenuItem;
exports.menuVersionFromDates = menuVersionFromDates;
exports.menuVersionFromItems = menuVersionFromItems;
exports.asNumber = asNumber;
const customization_pricing_1 = require("../common/menu/customization-pricing");
const big_int_1 = require("../common/utils/big-int");
function mapCategory(row) {
    return {
        id: row.id,
        restaurantId: row.restaurantId,
        name: row.name,
        sortOrder: row.sortOrder,
        isActive: row.isActive,
        createdAt: row.createdAt.toISOString(),
        updatedAt: row.updatedAt.toISOString(),
    };
}
function mapMenuItem(row) {
    return {
        id: row.id,
        restaurantId: row.restaurantId,
        categoryId: row.categoryId,
        name: row.name,
        description: row.description,
        basePrice: (0, customization_pricing_1.mapMoney)(row.basePriceMinor, row.currencyCode),
        availability: row.availability,
        imageUrl: row.imageUrl,
        sortOrder: row.sortOrder,
        isActive: row.isActive,
        createdAt: row.createdAt.toISOString(),
        updatedAt: row.updatedAt.toISOString(),
    };
}
function menuVersionFromDates(updatedAts) {
    if (updatedAts.length === 0)
        return 0;
    let maxMs = 0;
    for (const d of updatedAts) {
        maxMs = Math.max(maxMs, d.getTime());
    }
    return maxMs;
}
function menuVersionFromItems(items) {
    return menuVersionFromDates(items.map((i) => i.updatedAt));
}
function asNumber(value) {
    return (0, big_int_1.toNumber)(value);
}
//# sourceMappingURL=menu.mapper.js.map