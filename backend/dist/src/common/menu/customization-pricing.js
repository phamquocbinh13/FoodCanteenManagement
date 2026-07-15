"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapMoney = mapMoney;
exports.mapGroup = mapGroup;
exports.mapOption = mapOption;
exports.readSelectionGroups = readSelectionGroups;
exports.readCartNote = readCartNote;
exports.validateAndPrice = validateAndPrice;
const big_int_1 = require("../utils/big-int");
function mapMoney(amountMinor, currencyCode) {
    return { amountMinor: (0, big_int_1.toNumber)(amountMinor), currencyCode };
}
function mapGroup(row) {
    return {
        id: row.id,
        menuItemId: row.menu_item_id,
        key: row.group_key,
        name: row.name,
        selectionType: row.selection_type,
        isRequired: row.is_required,
        minSelections: row.min_selections,
        maxSelections: row.max_selections,
        sortOrder: row.sort_order,
        isActive: row.is_active,
        createdAt: row.created_at.toISOString(),
        updatedAt: row.updated_at.toISOString(),
        options: row.customization_option
            .slice()
            .sort((a, b) => a.sort_order - b.sort_order)
            .map(mapOption),
    };
}
function mapOption(row) {
    return {
        id: row.id,
        groupId: row.group_id,
        key: row.option_key,
        name: row.name,
        kitchenLabel: row.kitchen_label,
        priceDelta: mapMoney(row.price_delta_minor, row.currency_code),
        isDefault: row.is_default,
        sortOrder: row.sort_order,
        isActive: row.is_active,
        createdAt: row.created_at.toISOString(),
        updatedAt: row.updated_at.toISOString(),
    };
}
function readSelectionGroups(selectionsJson) {
    const result = new Map();
    if (!selectionsJson || typeof selectionsJson !== 'object')
        return result;
    const raw = selectionsJson['groups'];
    if (!raw || typeof raw !== 'object')
        return result;
    for (const [groupKey, value] of Object.entries(raw)) {
        if (value &&
            typeof value === 'object' &&
            Array.isArray(value.optionKeys)) {
            result.set(groupKey, (value.optionKeys).map(String));
        }
    }
    return result;
}
function readCartNote(selectionsJson) {
    if (!selectionsJson)
        return null;
    const note = selectionsJson['note'];
    if (typeof note === 'string' && note.trim())
        return note.trim();
    return null;
}
function validateAndPrice(params) {
    const selected = readSelectionGroups(params.selectionsJson);
    const noteParts = [];
    const customizations = [];
    let unitPrice = params.basePriceMinor;
    for (const group of params.groups) {
        if (!group.is_active)
            continue;
        const keys = selected.get(group.group_key) ?? [];
        const options = group.customization_option.filter((o) => o.is_active);
        if (group.is_required && keys.length === 0) {
            throw Object.assign(new Error(`Required modifier: ${group.name}`), {
                code: 'REQUIRED_MODIFIER_MISSING',
            });
        }
        if (keys.length < group.min_selections) {
            throw Object.assign(new Error(`Select at least ${group.min_selections} for ${group.name}`), { code: 'MODIFIER_MIN_NOT_MET' });
        }
        if (keys.length > group.max_selections) {
            throw Object.assign(new Error(`Select at most ${group.max_selections} for ${group.name}`), { code: 'MODIFIER_MAX_EXCEEDED' });
        }
        if (group.selection_type === 'single_select' && keys.length > 1) {
            throw Object.assign(new Error(`Only one selection allowed for ${group.name}`), { code: 'MODIFIER_SINGLE_ONLY' });
        }
        for (const key of keys) {
            const option = options.find((o) => o.option_key === key);
            if (!option) {
                throw Object.assign(new Error(`Invalid option for ${group.name}`), { code: 'INVALID_MODIFIER_OPTION' });
            }
            unitPrice += option.price_delta_minor;
            customizations.push({
                groupKey: group.group_key,
                groupNameSnapshot: group.name,
                optionKey: option.option_key,
                optionNameSnapshot: option.name,
                valueJson: {},
                priceDeltaMinor: option.price_delta_minor,
                currencyCode: option.currency_code,
                kitchenLabelRendered: option.kitchen_label,
            });
            noteParts.push(option.kitchen_label);
        }
    }
    const freeNote = readCartNote(params.selectionsJson);
    if (freeNote) {
        customizations.push({
            groupKey: 'note',
            groupNameSnapshot: 'Note',
            optionKey: null,
            optionNameSnapshot: null,
            valueJson: { text: freeNote },
            priceDeltaMinor: 0n,
            currencyCode: params.currencyCode,
            kitchenLabelRendered: freeNote,
        });
        noteParts.push(freeNote);
    }
    return {
        unitPriceMinor: unitPrice,
        currencyCode: params.currencyCode,
        kitchenNotes: noteParts.join(' · '),
        customizations,
    };
}
//# sourceMappingURL=customization-pricing.js.map