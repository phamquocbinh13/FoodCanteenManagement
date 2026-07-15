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
exports.BatchesService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const customization_pricing_1 = require("../common/menu/customization-pricing");
const prisma_service_1 = require("../prisma/prisma.service");
const batches_mapper_1 = require("./batches.mapper");
let BatchesService = class BatchesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async confirmFromCart(restaurantId, sessionId, dto = {}) {
        const session = await this.requireOpenSession(restaurantId, sessionId);
        const table = await this.prisma.restaurantTable.findUnique({
            where: { id: session.table_id },
        });
        if (!table) {
            throw (0, api_exception_1.notFound)('TABLE_NOT_FOUND', 'Table not found');
        }
        const cart = await this.prisma.session_cart.findUnique({
            where: { session_id: sessionId },
            include: { session_cart_item: { orderBy: { created_at: 'asc' } } },
        });
        if (!cart || cart.session_cart_item.length === 0) {
            throw (0, api_exception_1.unprocessable)('CART_EMPTY', 'Cart is empty');
        }
        const actorType = dto.actorType ?? 'customer_session';
        const actorId = dto.actorId ?? null;
        const now = new Date();
        const menuItemIds = [
            ...new Set(cart.session_cart_item.map((l) => l.menu_item_id)),
        ];
        const menuItems = await this.prisma.menuItem.findMany({
            where: { id: { in: menuItemIds }, restaurantId },
        });
        const menuById = new Map(menuItems.map((m) => [m.id, m]));
        const groups = await this.prisma.customization_group.findMany({
            where: { menu_item_id: { in: menuItemIds }, is_active: true },
            include: {
                customization_option: {
                    where: { is_active: true },
                    orderBy: { sort_order: 'asc' },
                },
            },
            orderBy: { sort_order: 'asc' },
        });
        const groupsByMenuId = new Map();
        for (const g of groups) {
            const list = groupsByMenuId.get(g.menu_item_id) ?? [];
            list.push(g);
            groupsByMenuId.set(g.menu_item_id, list);
        }
        const ticket = await this.prisma.$transaction(async (tx) => {
            const nextBatchNumber = session.current_batch_number + 1;
            const batchId = (0, uuid_1.v4)();
            const batch = await tx.kitchen_batch.create({
                data: {
                    id: batchId,
                    restaurant_id: restaurantId,
                    session_id: sessionId,
                    order_id: null,
                    batch_number: nextBatchNumber,
                    confirmed_at: now,
                    confirmed_by_actor_type: actorType,
                    confirmed_by_actor_id: actorId,
                    created_at: now,
                },
            });
            const createdItems = [];
            for (const line of cart.session_cart_item) {
                const menuItem = menuById.get(line.menu_item_id);
                if (!menuItem || !menuItem.isActive) {
                    throw (0, api_exception_1.unprocessable)('MENU_ITEM_NOT_FOUND', 'Menu item no longer exists');
                }
                if (menuItem.availability !== 'available') {
                    throw (0, api_exception_1.unprocessable)('MENU_ITEM_UNAVAILABLE', `Menu item unavailable: ${menuItem.name}`);
                }
                const itemGroups = groupsByMenuId.get(menuItem.id) ?? [];
                const selectionsJson = (line.selections_json ?? {});
                let priced;
                try {
                    priced = (0, customization_pricing_1.validateAndPrice)({
                        basePriceMinor: menuItem.basePriceMinor,
                        currencyCode: menuItem.currencyCode,
                        groups: itemGroups,
                        selectionsJson,
                    });
                }
                catch (e) {
                    const err = e;
                    throw (0, api_exception_1.unprocessable)(err.code ?? 'INVALID_SELECTIONS', err.message);
                }
                const batchItemId = (0, uuid_1.v4)();
                const lineTotal = (0, batches_mapper_1.lineTotalMinor)(priced.unitPriceMinor, line.quantity);
                const batchItem = await tx.batch_item.create({
                    data: {
                        id: batchItemId,
                        batch_id: batchId,
                        restaurant_id: restaurantId,
                        menu_item_id: menuItem.id,
                        menu_item_name_snapshot: menuItem.name,
                        unit_price_minor: priced.unitPriceMinor,
                        currency_code: priced.currencyCode,
                        quantity: line.quantity,
                        line_total_minor: lineTotal,
                        kitchen_notes_rendered: priced.kitchenNotes,
                        status: 'preparing',
                        status_updated_at: now,
                        created_at: now,
                    },
                });
                for (const mod of priced.customizations) {
                    await tx.batch_item_customization.create({
                        data: {
                            id: (0, uuid_1.v4)(),
                            batch_item_id: batchItemId,
                            group_key: mod.groupKey,
                            group_name_snapshot: mod.groupNameSnapshot,
                            option_key: mod.optionKey,
                            option_name_snapshot: mod.optionNameSnapshot,
                            value_json: mod.valueJson,
                            price_delta_minor: mod.priceDeltaMinor,
                            currency_code: mod.currencyCode,
                            kitchen_label_rendered: mod.kitchenLabelRendered,
                            created_at: now,
                        },
                    });
                }
                createdItems.push((0, batches_mapper_1.mapBatchItem)(batchItem));
            }
            await tx.session_cart_item.deleteMany({
                where: { session_cart_id: cart.id },
            });
            await tx.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            });
            await this._recalculateSessionTotals(tx, sessionId, session);
            await tx.dine_in_session.update({
                where: { id: sessionId },
                data: {
                    current_batch_number: nextBatchNumber,
                },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: sessionId,
                    event_type: 'batch_confirmed',
                    payload_json: {
                        batchId,
                        batchNumber: nextBatchNumber,
                    },
                    actor_type: actorType,
                    actor_id: actorId,
                    occurred_at: now,
                },
            });
            return {
                batch: (0, batches_mapper_1.mapBatch)(batch),
                tableLabel: table.label,
                items: createdItems,
            };
        });
        return ticket;
    }
    async getProgress(restaurantId, sessionId) {
        await this.requireSession(restaurantId, sessionId);
        const batches = await this.prisma.kitchen_batch.findMany({
            where: { session_id: sessionId, restaurant_id: restaurantId },
            include: { batch_item: true },
            orderBy: { batch_number: 'asc' },
        });
        const progress = batches.map((b) => {
            const completed = b.completed_at != null ||
                (b.batch_item.length > 0 &&
                    b.batch_item.every((i) => i.status === 'completed'));
            return {
                batchNumber: b.batch_number,
                statusLabel: completed ? 'Đã hoàn thành' : 'Đang chuẩn bị',
                isCompleted: completed,
                items: b.batch_item.map(batches_mapper_1.mapBatchItem),
            };
        });
        return { progress };
    }
    async listSessionBatches(restaurantId, sessionId) {
        await this.requireSession(restaurantId, sessionId);
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
            include: { restaurant_table: true },
        });
        if (!session) {
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        const batches = await this.prisma.kitchen_batch.findMany({
            where: { session_id: sessionId, restaurant_id: restaurantId },
            include: { batch_item: { orderBy: { created_at: 'asc' } } },
            orderBy: { batch_number: 'asc' },
        });
        return {
            batches: batches.map((b) => ({
                batch: (0, batches_mapper_1.mapBatch)(b),
                tableLabel: session.restaurant_table.label,
                items: b.batch_item.map(batches_mapper_1.mapBatchItem),
            })),
        };
    }
    async createBatch(restaurantId, sessionId, dto) {
        const session = await this.requireOpenSession(restaurantId, sessionId);
        const now = new Date();
        const batchNumber = dto.batchNumber ?? session.current_batch_number + 1;
        const batch = await this.prisma.$transaction(async (tx) => {
            const created = await tx.kitchen_batch.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    restaurant_id: restaurantId,
                    session_id: sessionId,
                    order_id: null,
                    batch_number: batchNumber,
                    confirmed_at: now,
                    confirmed_by_actor_type: dto.confirmedByActorType ?? 'user',
                    confirmed_by_actor_id: dto.confirmedByActorId ?? null,
                    created_at: now,
                },
            });
            if (batchNumber > session.current_batch_number) {
                await tx.dine_in_session.update({
                    where: { id: sessionId },
                    data: {
                        current_batch_number: batchNumber,
                        updated_at: now,
                    },
                });
            }
            return created;
        });
        return (0, batches_mapper_1.mapBatch)(batch);
    }
    async createBatchItem(restaurantId, batchId, dto) {
        const batch = await this.prisma.kitchen_batch.findFirst({
            where: { id: batchId, restaurant_id: restaurantId },
        });
        if (!batch) {
            throw (0, api_exception_1.notFound)('BATCH_NOT_FOUND', 'Batch not found');
        }
        const now = new Date();
        const row = await this.prisma.batch_item.create({
            data: {
                id: (0, uuid_1.v4)(),
                batch_id: batchId,
                restaurant_id: restaurantId,
                menu_item_id: dto.menuItemId,
                menu_item_name_snapshot: dto.menuItemNameSnapshot,
                unit_price_minor: BigInt(dto.unitPriceMinor),
                currency_code: dto.currencyCode,
                quantity: dto.quantity,
                line_total_minor: BigInt(dto.lineTotalMinor),
                kitchen_notes_rendered: dto.kitchenNotesRendered ?? '',
                status: 'preparing',
                status_updated_at: now,
                created_at: now,
            },
        });
        return (0, batches_mapper_1.mapBatchItem)(row);
    }
    async createCustomizations(restaurantId, batchItemId, dto) {
        const item = await this.prisma.batch_item.findFirst({
            where: { id: batchItemId, restaurant_id: restaurantId },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('BATCH_ITEM_NOT_FOUND', 'Batch item not found');
        }
        const now = new Date();
        await this.prisma.batch_item_customization.createMany({
            data: dto.customizations.map((c) => ({
                id: (0, uuid_1.v4)(),
                batch_item_id: batchItemId,
                group_key: c.groupKey,
                group_name_snapshot: c.groupNameSnapshot,
                option_key: c.optionKey ?? null,
                option_name_snapshot: c.optionNameSnapshot ?? null,
                value_json: (c.valueJson ?? {}),
                price_delta_minor: BigInt(c.priceDeltaMinor ?? 0),
                currency_code: c.currencyCode,
                kitchen_label_rendered: c.kitchenLabelRendered,
                created_at: now,
            })),
        });
        return { count: dto.customizations.length };
    }
    async getBatch(restaurantId, batchId) {
        const batch = await this.prisma.kitchen_batch.findFirst({
            where: { id: batchId, restaurant_id: restaurantId },
            include: {
                batch_item: { orderBy: { created_at: 'asc' } },
                dine_in_session: { include: { restaurant_table: true } },
            },
        });
        if (!batch) {
            throw (0, api_exception_1.notFound)('BATCH_NOT_FOUND', 'Batch not found');
        }
        return {
            batch: (0, batches_mapper_1.mapBatch)(batch),
            tableLabel: batch.dine_in_session?.restaurant_table.label ?? '',
            items: batch.batch_item.map(batches_mapper_1.mapBatchItem),
        };
    }
    async updateItemQuantity(restaurantId, batchItemId, delta) {
        await this.prisma.$transaction(async (tx) => {
            const item = await tx.batch_item.findFirst({
                where: { id: batchItemId, restaurant_id: restaurantId },
                include: { kitchen_batch: true },
            });
            if (!item) {
                throw (0, api_exception_1.notFound)('BATCH_ITEM_NOT_FOUND', 'Batch item not found');
            }
            const session = await tx.dine_in_session.findUnique({
                where: { id: item.kitchen_batch.session_id },
            });
            if (!session)
                throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
            const newQty = item.quantity + delta;
            if (newQty <= 0) {
                await tx.batch_item_customization.deleteMany({
                    where: { batch_item_id: batchItemId },
                });
                await tx.batch_item.delete({ where: { id: batchItemId } });
                const remaining = await tx.batch_item.count({
                    where: { batch_id: item.batch_id },
                });
                if (remaining === 0) {
                    await tx.kitchen_batch.delete({ where: { id: item.batch_id } });
                }
            }
            else {
                const newLineTotal = item.unit_price_minor * BigInt(newQty);
                await tx.batch_item.update({
                    where: { id: batchItemId },
                    data: {
                        quantity: newQty,
                        line_total_minor: newLineTotal,
                    },
                });
            }
            await this._recalculateSessionTotals(tx, session.id, session);
        });
    }
    async deleteItem(restaurantId, batchItemId) {
        await this.prisma.$transaction(async (tx) => {
            const item = await tx.batch_item.findFirst({
                where: { id: batchItemId, restaurant_id: restaurantId },
                include: { kitchen_batch: true },
            });
            if (!item) {
                throw (0, api_exception_1.notFound)('BATCH_ITEM_NOT_FOUND', 'Batch item not found');
            }
            const session = await tx.dine_in_session.findUnique({
                where: { id: item.kitchen_batch.session_id },
            });
            if (!session)
                throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
            await tx.batch_item_customization.deleteMany({
                where: { batch_item_id: batchItemId },
            });
            await tx.batch_item.delete({ where: { id: batchItemId } });
            const remaining = await tx.batch_item.count({
                where: { batch_id: item.batch_id },
            });
            if (remaining === 0) {
                await tx.kitchen_batch.delete({ where: { id: item.batch_id } });
            }
            await this._recalculateSessionTotals(tx, session.id, session);
        });
    }
    async requireSession(restaurantId, sessionId) {
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
        });
        if (!session) {
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        return session;
    }
    async requireOpenSession(restaurantId, sessionId) {
        const session = await this.requireSession(restaurantId, sessionId);
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
        }
        return session;
    }
    async _recalculateSessionTotals(tx, sessionId, session) {
        const allItems = await tx.batch_item.findMany({
            where: {
                kitchen_batch: { session_id: sessionId },
            },
        });
        let subtotal = 0n;
        for (const bi of allItems) {
            subtotal += bi.line_total_minor;
        }
        const discount = session.payment_discount_minor;
        const tax = session.payment_tax_minor;
        const service = session.payment_service_charge_minor;
        let total = subtotal - discount + tax + service;
        if (total < 0n)
            total = 0n;
        await tx.dine_in_session.update({
            where: { id: sessionId },
            data: {
                payment_subtotal_minor: subtotal,
                payment_total_minor: total,
                updated_at: new Date(),
            },
        });
    }
};
exports.BatchesService = BatchesService;
exports.BatchesService = BatchesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], BatchesService);
//# sourceMappingURL=batches.service.js.map