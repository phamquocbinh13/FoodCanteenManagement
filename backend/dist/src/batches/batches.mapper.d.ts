import { batch_item, kitchen_batch } from '@prisma/client';
import { type MoneyDto } from '../common/menu/customization-pricing';
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
};
export declare function mapBatch(row: kitchen_batch): KitchenBatchDto;
export declare function mapBatchItem(row: batch_item): BatchItemDto;
export declare function lineTotalMinor(unit: bigint, qty: number): bigint;
export declare function toNum(v: bigint | number): number;
