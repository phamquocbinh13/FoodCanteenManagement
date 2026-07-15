import { MenuCategory, MenuItem } from '@prisma/client';
import { mapMoney, type MoneyDto } from '../common/menu/customization-pricing';
import { toNumber } from '../common/utils/big-int';

export type MenuCategoryDto = {
  id: string;
  restaurantId: string;
  name: string;
  sortOrder: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
};

export type MenuItemDto = {
  id: string;
  restaurantId: string;
  categoryId: string;
  name: string;
  description: string | null;
  basePrice: MoneyDto;
  availability: string;
  imageUrl: string | null;
  sortOrder: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
};

export function mapCategory(row: MenuCategory): MenuCategoryDto {
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

export function mapMenuItem(row: MenuItem): MenuItemDto {
  return {
    id: row.id,
    restaurantId: row.restaurantId,
    categoryId: row.categoryId,
    name: row.name,
    description: row.description,
    basePrice: mapMoney(row.basePriceMinor, row.currencyCode),
    availability: row.availability,
    imageUrl: row.imageUrl,
    sortOrder: row.sortOrder,
    isActive: row.isActive,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

export function menuVersionFromDates(updatedAts: Date[]): number {
  if (updatedAts.length === 0) return 0;
  let maxMs = 0;
  for (const d of updatedAts) {
    maxMs = Math.max(maxMs, d.getTime());
  }
  return maxMs;
}

export function menuVersionFromItems(items: MenuItem[]): number {
  return menuVersionFromDates(items.map((i) => i.updatedAt));
}

/** Expose numeric helper for kitchen panel if needed. */
export function asNumber(value: bigint | number): number {
  return toNumber(value);
}
