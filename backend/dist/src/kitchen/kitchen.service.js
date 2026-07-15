"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.KitchenService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const batches_mapper_1 = require("../batches/batches.mapper");
const prisma_service_1 = require("../prisma/prisma.service");
let KitchenService = class KitchenService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getQueue(restaurantId) {
        const restaurant = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
        });
        if (!restaurant) {
            throw (0, api_exception_1.notFound)('RESTAURANT_NOT_FOUND', 'Restaurant not found');
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
        const views = batches.map((b) => {
            const allDone = b.completed_at != null ||
                (b.batch_item.length > 0 &&
                    b.batch_item.every((i) => i.status === 'completed' || i.status === 'served'));
            return {
                batch: (0, batches_mapper_1.mapBatch)(b),
                tableLabel: b.dine_in_session?.restaurant_table.label ?? '',
                items: b.batch_item.map(batches_mapper_1.mapBatchItem),
                sessionDisplayNumber: b.dine_in_session?.display_number ?? '',
                status: allDone ? 'completed' : 'pending',
            };
        });
        return { batches: views, loadedAt: new Date().toISOString() };
    }
    async getOverview(restaurantId) {
        const restaurant = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
        });
        if (!restaurant) {
            throw (0, api_exception_1.notFound)('RESTAURANT_NOT_FOUND', 'Restaurant not found');
        }
        const batches = await this.prisma.kitchen_batch.findMany({
            where: {
                restaurant_id: restaurantId,
                session_id: { not: null },
            },
            include: {
                batch_item: {
                    orderBy: { created_at: 'asc' },
                    include: {
                        menu_item: { include: { category: true } },
                    },
                },
                dine_in_session: { include: { restaurant_table: true } },
            },
            orderBy: { confirmed_at: 'asc' },
        });
        const now = Date.now();
        const isItemDone = (status) => status === 'completed' || status === 'served';
        const isBatchDone = (b) => b.completed_at != null ||
            (b.batch_item.length > 0 && b.batch_item.every((i) => isItemDone(i.status)));
        const activeBatches = batches.filter((b) => !isBatchDone(b));
        const readyBatches = batches.filter((b) => isBatchDone(b));
        let ordersPreparing = 0;
        let ordersWaiting = 0;
        for (const b of activeBatches) {
            const hasPreparing = b.batch_item.some((i) => i.status === 'preparing');
            if (hasPreparing) {
                ordersPreparing += 1;
            }
            else {
                ordersWaiting += 1;
            }
        }
        const ordersReady = readyBatches.length;
        let totalFoodOrders = 0;
        let totalDrinkOrders = 0;
        const demandMap = new Map();
        for (const b of activeBatches) {
            for (const item of b.batch_item) {
                if (isItemDone(item.status))
                    continue;
                const qty = item.quantity;
                if (qty <= 0)
                    continue;
                const categoryName = item.menu_item?.category?.name?.toLowerCase() ?? '';
                const isDrink = categoryName.includes('drink') ||
                    categoryName.includes('beverage') ||
                    categoryName.includes('đồ uống');
                if (isDrink) {
                    totalDrinkOrders += qty;
                }
                else {
                    totalFoodOrders += qty;
                }
                const key = item.menu_item_id;
                const existing = demandMap.get(key);
                if (existing) {
                    existing.quantity += qty;
                }
                else {
                    demandMap.set(key, {
                        menuItemId: item.menu_item_id,
                        name: item.menu_item_name_snapshot,
                        quantity: qty,
                    });
                }
            }
        }
        const waitingMinutes = activeBatches.map((b) => Math.max(0, (now - b.confirmed_at.getTime()) / 60_000));
        const averageWaitingMinutes = waitingMinutes.length === 0
            ? 0
            : Math.round((waitingMinutes.reduce((a, m) => a + m, 0) /
                waitingMinutes.length) *
                10) / 10;
        let longestWaitingTable = null;
        let longestWaitingMinutes = 0;
        if (activeBatches.length > 0) {
            const oldest = activeBatches[0];
            longestWaitingTable =
                oldest.dine_in_session?.restaurant_table.label ?? null;
            longestWaitingMinutes = Math.round(Math.max(0, (now - oldest.confirmed_at.getTime()) / 60_000));
        }
        const menuDemand = Array.from(demandMap.values())
            .filter((d) => d.quantity > 0)
            .sort((a, b) => b.quantity - a.quantity);
        return {
            totalActiveOrders: activeBatches.length,
            totalFoodOrders,
            totalDrinkOrders,
            averageWaitingMinutes,
            longestWaitingTable,
            longestWaitingMinutes,
            ordersReady,
            ordersPreparing,
            ordersWaiting,
            menuDemand,
        };
    }
    async completeBatchItem(restaurantId, batchItemId, changedByUserId) {
        const item = await this.prisma.batch_item.findFirst({
            where: { id: batchItemId, restaurant_id: restaurantId },
            include: { kitchen_batch: true },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('BATCH_ITEM_NOT_FOUND', 'Batch item not found');
        }
        if (item.status !== 'preparing') {
            throw (0, api_exception_1.unprocessable)('INVALID_STATUS', 'Only preparing items can be completed');
        }
        const now = new Date();
        await this.prisma.$transaction(async (tx) => {
            await tx.batch_item.update({
                where: { id: batchItemId },
                data: { status: 'completed', status_updated_at: now },
            });
            await tx.batch_item_status_history.create({
                data: {
                    id: (0, uuid_1.v4)(),
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
            const allDone = siblings.every((s) => s.id === batchItemId ||
                s.status === 'completed' ||
                s.status === 'served');
            if (allDone && item.kitchen_batch.completed_at == null) {
                await tx.kitchen_batch.update({
                    where: { id: item.batch_id },
                    data: { completed_at: now },
                });
            }
            if (item.kitchen_batch.session_id) {
                await tx.session_timeline_event.create({
                    data: {
                        id: (0, uuid_1.v4)(),
                        session_id: item.kitchen_batch.session_id,
                        event_type: 'batch_item_completed',
                        payload_json: {
                            batchNumber: item.kitchen_batch.batch_number,
                            menuItemName: item.menu_item_name_snapshot,
                        },
                        actor_type: 'user',
                        actor_id: changedByUserId,
                        occurred_at: now,
                    },
                });
            }
        });
        return { ok: true };
    }
};
exports.KitchenService = KitchenService;
exports.KitchenService = KitchenService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], KitchenService);
//# sourceMappingURL=kitchen.service.js.map