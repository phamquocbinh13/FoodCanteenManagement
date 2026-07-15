import { Prisma } from '@prisma/client';
import { toNumber } from '../utils/big-int';

export type MoneyDto = {
  amountMinor: number;
  currencyCode: string;
};

export type CatalogGroup = {
  id: string;
  menuItemId: string;
  key: string;
  name: string;
  selectionType: string;
  isRequired: boolean;
  minSelections: number;
  maxSelections: number;
  sortOrder: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
  options: CatalogOption[];
};

export type CatalogOption = {
  id: string;
  groupId: string;
  key: string;
  name: string;
  kitchenLabel: string;
  priceDelta: MoneyDto;
  isDefault: boolean;
  sortOrder: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
};

type GroupRow = {
  id: string;
  menu_item_id: string;
  group_key: string;
  name: string;
  selection_type: string;
  is_required: boolean;
  min_selections: number;
  max_selections: number;
  sort_order: number;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
  customization_option: OptionRow[];
};

type OptionRow = {
  id: string;
  group_id: string;
  option_key: string;
  name: string;
  kitchen_label: string;
  price_delta_minor: bigint;
  currency_code: string;
  is_default: boolean;
  sort_order: number;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
};

export function mapMoney(
  amountMinor: bigint | number,
  currencyCode: string,
): MoneyDto {
  return { amountMinor: toNumber(amountMinor), currencyCode };
}

export function mapGroup(row: GroupRow): CatalogGroup {
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

export function mapOption(row: OptionRow): CatalogOption {
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

/** selectionsJson shape: { groups: { [groupKey]: { optionKeys: string[] } }, note?: string } */
export function readSelectionGroups(
  selectionsJson: Record<string, unknown> | null | undefined,
): Map<string, string[]> {
  const result = new Map<string, string[]>();
  if (!selectionsJson || typeof selectionsJson !== 'object') return result;
  const raw = selectionsJson['groups'];
  if (!raw || typeof raw !== 'object') return result;

  for (const [groupKey, value] of Object.entries(
    raw as Record<string, unknown>,
  )) {
    if (
      value &&
      typeof value === 'object' &&
      Array.isArray((value as { optionKeys?: unknown }).optionKeys)
    ) {
      result.set(
        groupKey,
        ((value as { optionKeys: unknown[] }).optionKeys).map(String),
      );
    }
  }
  return result;
}

export function readCartNote(
  selectionsJson: Record<string, unknown> | null | undefined,
): string | null {
  if (!selectionsJson) return null;
  const note = selectionsJson['note'];
  if (typeof note === 'string' && note.trim()) return note.trim();
  return null;
}

export type RenderedCustomization = {
  groupKey: string;
  groupNameSnapshot: string;
  optionKey: string | null;
  optionNameSnapshot: string | null;
  valueJson: Prisma.InputJsonValue;
  priceDeltaMinor: bigint;
  currencyCode: string;
  kitchenLabelRendered: string;
};

export type PriceRenderResult = {
  unitPriceMinor: bigint;
  currencyCode: string;
  kitchenNotes: string;
  customizations: RenderedCustomization[];
};

export function validateAndPrice(params: {
  basePriceMinor: bigint;
  currencyCode: string;
  groups: GroupRow[];
  selectionsJson: Record<string, unknown>;
}): PriceRenderResult {
  const selected = readSelectionGroups(params.selectionsJson);
  const noteParts: string[] = [];
  const customizations: RenderedCustomization[] = [];
  let unitPrice = params.basePriceMinor;

  for (const group of params.groups) {
    if (!group.is_active) continue;
    const keys = selected.get(group.group_key) ?? [];
    const options = group.customization_option.filter((o) => o.is_active);

    if (group.is_required && keys.length === 0) {
      throw Object.assign(new Error(`Required modifier: ${group.name}`), {
        code: 'REQUIRED_MODIFIER_MISSING',
      });
    }
    if (keys.length < group.min_selections) {
      throw Object.assign(
        new Error(`Select at least ${group.min_selections} for ${group.name}`),
        { code: 'MODIFIER_MIN_NOT_MET' },
      );
    }
    if (keys.length > group.max_selections) {
      throw Object.assign(
        new Error(`Select at most ${group.max_selections} for ${group.name}`),
        { code: 'MODIFIER_MAX_EXCEEDED' },
      );
    }
    if (group.selection_type === 'single_select' && keys.length > 1) {
      throw Object.assign(
        new Error(`Only one selection allowed for ${group.name}`),
        { code: 'MODIFIER_SINGLE_ONLY' },
      );
    }

    for (const key of keys) {
      const option = options.find((o) => o.option_key === key);
      if (!option) {
        throw Object.assign(
          new Error(`Invalid option for ${group.name}`),
          { code: 'INVALID_MODIFIER_OPTION' },
        );
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
