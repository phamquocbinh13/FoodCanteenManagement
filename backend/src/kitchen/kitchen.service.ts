import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import {
  notFound,
  unprocessable,
} from '../common/errors/api-exception';
import { mapBatchItem } from '../batches/batches.mapper';
import { PrismaService } from '../prisma/prisma.service';

export type KitchenQueueItemDto = {
  id: string;
  name: string;
  quantityLabel: string;
  kitchenNotes: string;
  status: string;
};

export type KitchenQueueBatchDto = {
  batchId: string;
  batchNumber: number;
  sessionDisplayNumber: string;
  tableLabel: string;
  createdAt: string;
  completedAt: string | null;
  status: 'pending' | 'completed';
  items: KitchenQueueItemDto[];
};

@Injectable()
export class KitchenService {
  constructor(private readonly prisma: PrismaService) {}

  async getQueue(restaurantId: string): Promise<{
    batches: KitchenQueueBatchDto[];
    loadedAt: string;
  }> {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id: restaurantId },
    });
    if (!restaurant) {
      throw notFound('RESTAURANT_NOT_FOUND', 'Restaurant not found');
    }

    const batches = await this.prisma.kitchen_batch.findMany({
      where: {
        restaurant_id: restaurantId,
        session_id: { not: null },
      },
      include: {
        batch_item: { orderBy: { created_at: 'asc' } },
        dine_in_session: { include: { restaurant_table: true } },
      },
      orderBy: { confirmed_at: 'asc' },
    });

    const views: KitchenQueueBatchDto[] = batches.map((b) => {
      const allDone =
        b.completed_at != null ||
        (b.batch_item.length > 0 &&
          b.batch_item.every((i) => i.status === 'completed'));
      return {
        batchId: b.id,
        batchNumber: b.batch_number,
        sessionDisplayNumber: b.dine_in_session?.display_number ?? '',
        tableLabel: b.dine_in_session?.restaurant_table.label ?? '',
        createdAt: b.confirmed_at.toISOString(),
        completedAt: b.completed_at?.toISOString() ?? null,
        status: allDone ? 'completed' : 'pending',
        items: b.batch_item.map((i) => ({
          id: i.id,
          name: i.menu_item_name_snapshot,
          quantityLabel: `x${i.quantity}`,
          kitchenNotes: i.kitchen_notes_rendered,
          status: i.status,
        })),
      };
    });

    return { batches: views, loadedAt: new Date().toISOString() };
  }

  async completeBatchItem(
    restaurantId: string,
    batchItemId: string,
    changedByUserId: string,
  ) {
    const item = await this.prisma.batch_item.findFirst({
      where: { id: batchItemId, restaurant_id: restaurantId },
      include: { kitchen_batch: true },
    });
    if (!item) {
      throw notFound('BATCH_ITEM_NOT_FOUND', 'Batch item not found');
    }
    if (item.status !== 'preparing') {
      throw unprocessable(
        'INVALID_STATUS',
        'Only preparing items can be completed',
      );
    }

    const now = new Date();
    const updated = await this.prisma.$transaction(async (tx) => {
      const row = await tx.batch_item.update({
        where: { id: batchItemId },
        data: {
          status: 'completed',
          status_updated_at: now,
        },
      });
      await tx.batch_item_status_history.create({
        data: {
          id: uuidv4(),
          batch_item_id: batchItemId,
          from_status: 'preparing',
          to_status: 'completed',
          changed_by_user_id: changedByUserId,
          occurred_at: now,
        },
      });

      const siblings = await tx.batch_item.findMany({
        where: { batch_id: item.batch_id },
      });
      const allDone = siblings.every((s) => s.status === 'completed');
      if (allDone && !item.kitchen_batch.completed_at) {
        await tx.kitchen_batch.update({
          where: { id: item.batch_id },
          data: { completed_at: now },
        });
        if (item.kitchen_batch.session_id) {
          await tx.session_timeline_event.create({
            data: {
              id: uuidv4(),
              session_id: item.kitchen_batch.session_id,
              event_type: 'batch_completed',
              payload_json: {
                batchId: item.batch_id,
                batchNumber: item.kitchen_batch.batch_number,
              },
              actor_type: 'user',
              actor_id: changedByUserId,
              occurred_at: now,
            },
          });
        }
      } else if (item.kitchen_batch.session_id) {
        await tx.session_timeline_event.create({
          data: {
            id: uuidv4(),
            session_id: item.kitchen_batch.session_id,
            event_type: 'batch_item_completed',
            payload_json: { batchItemId },
            actor_type: 'user',
            actor_id: changedByUserId,
            occurred_at: now,
          },
        });
      }

      return row;
    });

    return mapBatchItem(updated);
  }
}
