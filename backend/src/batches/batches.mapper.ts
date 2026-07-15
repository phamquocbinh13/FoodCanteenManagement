import { batch_item, kitchen_batch } from '@prisma/client';
import { mapMoney, type MoneyDto } from '../common/menu/customization-pricing';
import { toNumber } from '../common/utils/big-int';

export type KitchenBatchDto = {
  id: string;
  restaurantId: string;
  sessionId: string | null;
  orderId: string | null;
  batchNumber: number;
  confirmedAt: string;
  confirmedByActorType: string;
  confirmedByActorId: string | null;
  completedAt: string | null;
  createdAt: string;
};

export type BatchItemDto = {
  id: string;
  batchId: string;
  menuItemId: string;
  menuItemNameSnapshot: string;
  unitPriceSnapshot: MoneyDto;
  quantity: number;
  lineTotal: MoneyDto;
  kitchenNotesRendered: string;
  status: string;
  statusUpdatedAt: string;
  createdAt: string;
};

export type KitchenBatchTicketDto = {
  batch: KitchenBatchDto;
  tableLabel: string;
  items: BatchItemDto[];
};

export type BatchProgressDto = {
  batchNumber: number;
  statusLabel: string;
  isCompleted: boolean;
  items: BatchItemDto[];
};

export function mapBatch(row: kitchen_batch): KitchenBatchDto {
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

export function mapBatchItem(row: batch_item): BatchItemDto {
  return {
    id: row.id,
    batchId: row.batch_id,
    menuItemId: row.menu_item_id,
    menuItemNameSnapshot: row.menu_item_name_snapshot,
    unitPriceSnapshot: mapMoney(row.unit_price_minor, row.currency_code),
    quantity: row.quantity,
    lineTotal: mapMoney(row.line_total_minor, row.currency_code),
    kitchenNotesRendered: row.kitchen_notes_rendered,
    status: row.status,
    statusUpdatedAt: row.status_updated_at.toISOString(),
    createdAt: row.created_at.toISOString(),
  };
}

export function lineTotalMinor(unit: bigint, qty: number): bigint {
  return unit * BigInt(qty);
}

export function toNum(v: bigint | number): number {
  return toNumber(v);
}
