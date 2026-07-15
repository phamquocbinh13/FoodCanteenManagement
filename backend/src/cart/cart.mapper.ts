import { Prisma, session_cart, session_cart_item } from '@prisma/client';
import { mapMoney, type MoneyDto } from '../common/menu/customization-pricing';

export type SessionCartDto = {
  id: string;
  sessionId: string;
  version: number;
  updatedAt: string;
  createdAt: string;
};

export type SessionCartItemDto = {
  id: string;
  sessionCartId: string;
  menuItemId: string;
  quantity: number;
  selectionsJson: Record<string, unknown>;
  unitPriceSnapshot: MoneyDto;
  createdAt: string;
  updatedAt: string;
};

export type CartResponse = {
  cart: SessionCartDto;
  items: SessionCartItemDto[];
};

export function mapCart(row: session_cart): SessionCartDto {
  return {
    id: row.id,
    sessionId: row.session_id,
    version: row.version,
    updatedAt: row.updated_at.toISOString(),
    createdAt: row.created_at.toISOString(),
  };
}

export function mapCartItem(row: session_cart_item): SessionCartItemDto {
  return {
    id: row.id,
    sessionCartId: row.session_cart_id,
    menuItemId: row.menu_item_id,
    quantity: row.quantity,
    selectionsJson: (row.selections_json ?? {}) as Record<string, unknown>,
    unitPriceSnapshot: mapMoney(row.unit_price_minor, row.currency_code),
    createdAt: row.created_at.toISOString(),
    updatedAt: row.updated_at.toISOString(),
  };
}

export function asJsonObject(
  value: unknown,
): Record<string, unknown> {
  if (value && typeof value === 'object' && !Array.isArray(value)) {
    return value as Record<string, unknown>;
  }
  return {};
}

export function toInputJson(
  value: Record<string, unknown>,
): Prisma.InputJsonValue {
  return value as Prisma.InputJsonValue;
}
