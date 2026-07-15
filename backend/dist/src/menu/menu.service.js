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
exports.MenuService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const customization_pricing_1 = require("../common/menu/customization-pricing");
const prisma_service_1 = require("../prisma/prisma.service");
const menu_mapper_1 = require("./menu.mapper");
let MenuService = class MenuService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getCatalog(restaurantId) {
        await this.requireRestaurant(restaurantId);
        const [categories, items] = await Promise.all([
            this.prisma.menuCategory.findMany({
                where: { restaurantId, isActive: true },
                orderBy: { sortOrder: 'asc' },
            }),
            this.prisma.menuItem.findMany({
                where: {
                    restaurantId,
                    isActive: true,
                    availability: 'available',
                },
                orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
            }),
        ]);
        const allForVersion = await this.prisma.menuItem.findMany({
            where: { restaurantId },
            select: { updatedAt: true },
        });
        return {
            menuVersion: (0, menu_mapper_1.menuVersionFromDates)(allForVersion.map((r) => r.updatedAt)),
            categories: categories.map(menu_mapper_1.mapCategory),
            items: items.map(menu_mapper_1.mapMenuItem),
        };
    }
    async getItemDetail(restaurantId, itemId) {
        const item = await this.prisma.menuItem.findFirst({
            where: { id: itemId, restaurantId },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('MENU_ITEM_NOT_FOUND', 'Menu item not found');
        }
        const groups = await this.prisma.customization_group.findMany({
            where: { menu_item_id: itemId, is_active: true },
            include: {
                customization_option: {
                    where: { is_active: true },
                    orderBy: { sort_order: 'asc' },
                },
            },
            orderBy: { sort_order: 'asc' },
        });
        return {
            item: (0, menu_mapper_1.mapMenuItem)(item),
            groups: groups.map(customization_pricing_1.mapGroup),
        };
    }
    async getKitchenMenu(restaurantId) {
        await this.requireRestaurant(restaurantId);
        const items = await this.prisma.menuItem.findMany({
            where: { restaurantId, isActive: true },
            orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
        });
        return { items: items.map(menu_mapper_1.mapMenuItem) };
    }
    async toggleAvailability(restaurantId, itemId, changedByUserId) {
        const item = await this.prisma.menuItem.findFirst({
            where: { id: itemId, restaurantId },
        });
        if (!item) {
            throw (0, api_exception_1.notFound)('MENU_ITEM_NOT_FOUND', 'Menu item not found');
        }
        if (!item.isActive) {
            throw (0, api_exception_1.unprocessable)('MENU_ITEM_INACTIVE', 'Menu item is inactive');
        }
        const from = item.availability;
        const to = from === 'available' ? 'out_of_stock' : 'available';
        const now = new Date();
        const staff = await this.prisma.staffUser.findFirst({
            where: { id: changedByUserId, restaurantId },
        });
        if (!staff) {
            throw (0, api_exception_1.forbidden)('STAFF_NOT_FOUND', 'Staff user not found for restaurant');
        }
        const updated = await this.prisma.$transaction(async (tx) => {
            const row = await tx.menuItem.update({
                where: { id: itemId },
                data: { availability: to, updatedAt: now },
            });
            await tx.menu_item_availability_history.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    menu_item_id: itemId,
                    from_availability: from,
                    to_availability: to,
                    changed_by_user_id: changedByUserId,
                    occurred_at: now,
                },
            });
            return row;
        });
        return (0, menu_mapper_1.mapMenuItem)(updated);
    }
    async requireRestaurant(restaurantId) {
        const r = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
        });
        if (!r) {
            throw (0, api_exception_1.notFound)('RESTAURANT_NOT_FOUND', 'Restaurant not found');
        }
    }
};
exports.MenuService = MenuService;
exports.MenuService = MenuService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], MenuService);
//# sourceMappingURL=menu.service.js.map