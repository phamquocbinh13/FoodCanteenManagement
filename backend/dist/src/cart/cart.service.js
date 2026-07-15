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
exports.CartService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const customization_pricing_1 = require("../common/menu/customization-pricing");
const prisma_service_1 = require("../prisma/prisma.service");
const cart_mapper_1 = require("./cart.mapper");
let CartService = class CartService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getCart(restaurantId, sessionId) {
        await this.requireOpenSession(restaurantId, sessionId);
        const cart = await this.getOrCreateCart(sessionId);
        const items = await this.prisma.session_cart_item.findMany({
            where: { session_cart_id: cart.id },
            orderBy: { created_at: 'asc' },
        });
        return { cart: (0, cart_mapper_1.mapCart)(cart), items: items.map(cart_mapper_1.mapCartItem) };
    }
    async addItem(restaurantId, sessionId, dto) {
        await this.requireOpenSession(restaurantId, sessionId);
        const menuItem = await this.prisma.menuItem.findFirst({
            where: { id: dto.menuItemId, restaurantId },
        });
        if (!menuItem || !menuItem.isActive) {
            throw (0, api_exception_1.notFound)('MENU_ITEM_NOT_FOUND', 'Menu item not found');
        }
        if (menuItem.availability !== 'available') {
            throw (0, api_exception_1.unprocessable)('MENU_ITEM_UNAVAILABLE', 'Menu item is unavailable');
        }
        const groups = await this.loadGroups(dto.menuItemId);
        const selectionsJson = (0, cart_mapper_1.asJsonObject)(dto.selectionsJson ?? {});
        let priced;
        try {
            priced = (0, customization_pricing_1.validateAndPrice)({
                basePriceMinor: menuItem.basePriceMinor,
                currencyCode: menuItem.currencyCode,
                groups,
                selectionsJson,
            });
        }
        catch (e) {
            const err = e;
            throw (0, api_exception_1.unprocessable)(err.code ?? 'INVALID_SELECTIONS', err.message);
        }
        const now = new Date();
        await this.prisma.$transaction(async (tx) => {
            const cart = await this.getOrCreateCartTx(tx, sessionId, now);
            await tx.session_cart_item.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_cart_id: cart.id,
                    menu_item_id: menuItem.id,
                    quantity: dto.quantity,
                    selections_json: (0, cart_mapper_1.toInputJson)(selectionsJson),
                    unit_price_minor: priced.unitPriceMinor,
                    currency_code: priced.currencyCode,
                    created_at: now,
                    updated_at: now,
                },
            });
            await tx.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: sessionId,
                    event_type: 'cart_item_added',
                    payload_json: {
                        menuItemId: menuItem.id,
                        quantity: dto.quantity,
                    },
                    actor_type: 'customer_session',
                    actor_id: null,
                    occurred_at: now,
                },
            });
        });
        return this.getCart(restaurantId, sessionId);
    }
    async patchItem(restaurantId, sessionId, itemId, dto) {
        await this.requireOpenSession(restaurantId, sessionId);
        if (dto.quantity == null && dto.delta == null) {
            throw (0, api_exception_1.unprocessable)('INVALID_PATCH', 'Provide quantity or delta');
        }
        const cart = await this.getOrCreateCart(sessionId);
        const item = await this.prisma.session_cart_item.findFirst({
            where: { id: itemId, session_cart_id: cart.id },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('CART_ITEM_NOT_FOUND', 'Cart item not found');
        }
        let nextQty = item.quantity;
        if (dto.quantity != null)
            nextQty = dto.quantity;
        else if (dto.delta != null)
            nextQty = item.quantity + dto.delta;
        if (nextQty < 1) {
            throw (0, api_exception_1.unprocessable)('INVALID_QUANTITY', 'Quantity must be at least 1');
        }
        const now = new Date();
        await this.prisma.$transaction([
            this.prisma.session_cart_item.update({
                where: { id: itemId },
                data: { quantity: nextQty, updated_at: now },
            }),
            this.prisma.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            }),
        ]);
        return this.getCart(restaurantId, sessionId);
    }
    async putSelections(restaurantId, sessionId, itemId, dto) {
        await this.requireOpenSession(restaurantId, sessionId);
        const cart = await this.getOrCreateCart(sessionId);
        const item = await this.prisma.session_cart_item.findFirst({
            where: { id: itemId, session_cart_id: cart.id },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('CART_ITEM_NOT_FOUND', 'Cart item not found');
        }
        const menuItem = await this.prisma.menuItem.findUnique({
            where: { id: item.menu_item_id },
        });
        if (!menuItem) {
            throw (0, api_exception_1.notFound)('MENU_ITEM_NOT_FOUND', 'Menu item not found');
        }
        const groups = await this.loadGroups(menuItem.id);
        const selectionsJson = (0, cart_mapper_1.asJsonObject)(dto.selectionsJson);
        let priced;
        try {
            priced = (0, customization_pricing_1.validateAndPrice)({
                basePriceMinor: menuItem.basePriceMinor,
                currencyCode: menuItem.currencyCode,
                groups,
                selectionsJson,
            });
        }
        catch (e) {
            const err = e;
            throw (0, api_exception_1.unprocessable)(err.code ?? 'INVALID_SELECTIONS', err.message);
        }
        const now = new Date();
        await this.prisma.$transaction([
            this.prisma.session_cart_item.update({
                where: { id: itemId },
                data: {
                    selections_json: (0, cart_mapper_1.toInputJson)(selectionsJson),
                    unit_price_minor: priced.unitPriceMinor,
                    currency_code: priced.currencyCode,
                    updated_at: now,
                },
            }),
            this.prisma.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            }),
        ]);
        return this.getCart(restaurantId, sessionId);
    }
    async removeItem(restaurantId, sessionId, itemId) {
        await this.requireOpenSession(restaurantId, sessionId);
        const cart = await this.getOrCreateCart(sessionId);
        const item = await this.prisma.session_cart_item.findFirst({
            where: { id: itemId, session_cart_id: cart.id },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('CART_ITEM_NOT_FOUND', 'Cart item not found');
        }
        const now = new Date();
        await this.prisma.$transaction(async (tx) => {
            await tx.session_cart_item.delete({ where: { id: itemId } });
            await tx.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: sessionId,
                    event_type: 'cart_item_removed',
                    payload_json: { cartItemId: itemId },
                    actor_type: 'customer_session',
                    actor_id: null,
                    occurred_at: now,
                },
            });
        });
        return this.getCart(restaurantId, sessionId);
    }
    async clearCart(restaurantId, sessionId) {
        await this.requireOpenSession(restaurantId, sessionId);
        const cart = await this.getOrCreateCart(sessionId);
        const now = new Date();
        await this.prisma.$transaction([
            this.prisma.session_cart_item.deleteMany({
                where: { session_cart_id: cart.id },
            }),
            this.prisma.session_cart.update({
                where: { id: cart.id },
                data: { version: cart.version + 1, updated_at: now },
            }),
        ]);
        return this.getCart(restaurantId, sessionId);
    }
    async listItemsInternal(sessionId) {
        const cart = await this.getOrCreateCart(sessionId);
        const rawItems = await this.prisma.session_cart_item.findMany({
            where: { session_cart_id: cart.id },
            orderBy: { created_at: 'asc' },
        });
        return {
            cartId: cart.id,
            cartVersion: cart.version,
            items: rawItems.map(cart_mapper_1.mapCartItem),
            rawItems,
        };
    }
    async loadGroups(menuItemId) {
        return this.prisma.customization_group.findMany({
            where: { menu_item_id: menuItemId, is_active: true },
            include: {
                customization_option: {
                    where: { is_active: true },
                    orderBy: { sort_order: 'asc' },
                },
            },
            orderBy: { sort_order: 'asc' },
        });
    }
    async requireOpenSession(restaurantId, sessionId) {
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
        });
        if (!session) {
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
        }
        return session;
    }
    async getOrCreateCart(sessionId) {
        const existing = await this.prisma.session_cart.findUnique({
            where: { session_id: sessionId },
        });
        if (existing)
            return existing;
        const now = new Date();
        return this.prisma.session_cart.create({
            data: {
                id: (0, uuid_1.v4)(),
                session_id: sessionId,
                version: 1,
                created_at: now,
                updated_at: now,
            },
        });
    }
    async getOrCreateCartTx(tx, sessionId, now) {
        const existing = await tx.session_cart.findUnique({
            where: { session_id: sessionId },
        });
        if (existing)
            return existing;
        return tx.session_cart.create({
            data: {
                id: (0, uuid_1.v4)(),
                session_id: sessionId,
                version: 1,
                created_at: now,
                updated_at: now,
            },
        });
    }
};
exports.CartService = CartService;
exports.CartService = CartService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], CartService);
//# sourceMappingURL=cart.service.js.map