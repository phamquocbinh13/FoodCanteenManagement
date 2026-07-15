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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RestaurantsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const prisma_service_1 = require("../prisma/prisma.service");
let RestaurantsController = class RestaurantsController {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findById(restaurantId) {
        const restaurant = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
            include: { settings: true },
        });
        if (!restaurant) {
            throw new common_1.NotFoundException({
                error: {
                    code: 'RESTAURANT_NOT_FOUND',
                    message: 'Restaurant not found',
                },
            });
        }
        return restaurant;
    }
    async listTables(restaurantId) {
        const items = await this.prisma.restaurantTable.findMany({
            where: { restaurantId, isActive: true },
            orderBy: { sortOrder: 'asc' },
        });
        return { items };
    }
};
exports.RestaurantsController = RestaurantsController;
__decorate([
    (0, common_1.Get)(':restaurantId'),
    (0, swagger_1.ApiOperation)({ summary: 'Get restaurant by id (B0 smoke endpoint)' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], RestaurantsController.prototype, "findById", null);
__decorate([
    (0, common_1.Get)(':restaurantId/tables'),
    (0, swagger_1.ApiOperation)({ summary: 'List tables for restaurant (B0 smoke endpoint)' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], RestaurantsController.prototype, "listTables", null);
exports.RestaurantsController = RestaurantsController = __decorate([
    (0, swagger_1.ApiTags)('restaurants'),
    (0, common_1.Controller)('restaurants'),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], RestaurantsController);
//# sourceMappingURL=restaurants.controller.js.map