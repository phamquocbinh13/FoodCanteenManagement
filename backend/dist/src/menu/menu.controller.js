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
exports.MenuController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_user_decorator_1 = require("../auth/decorators/current-user.decorator");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const menu_dto_1 = require("./dto/menu.dto");
const menu_service_1 = require("./menu.service");
let MenuController = class MenuController {
    menu;
    constructor(menu) {
        this.menu = menu;
    }
    getCatalog(restaurantId) {
        return this.menu.getCatalog(restaurantId);
    }
    getItem(restaurantId, itemId) {
        return this.menu.getItemDetail(restaurantId, itemId);
    }
    kitchenMenu(restaurantId) {
        return this.menu.getKitchenMenu(restaurantId);
    }
    toggle(restaurantId, itemId, user, dto) {
        return this.menu.toggleAvailability(restaurantId, itemId, dto.changedByUserId ?? user.sub);
    }
};
exports.MenuController = MenuController;
__decorate([
    (0, common_1.Get)('menu'),
    (0, swagger_1.ApiOperation)({ summary: 'Customer menu catalog' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MenuController.prototype, "getCatalog", null);
__decorate([
    (0, common_1.Get)('menu/items/:itemId'),
    (0, swagger_1.ApiOperation)({ summary: 'Menu item detail with customization groups' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('itemId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], MenuController.prototype, "getItem", null);
__decorate([
    (0, common_1.Get)('kitchen/menu'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, swagger_1.ApiOperation)({ summary: 'Kitchen menu panel — all active items' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MenuController.prototype, "kitchenMenu", null);
__decorate([
    (0, common_1.Post)('menu/items/:itemId/toggle-availability'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, swagger_1.ApiOperation)({ summary: 'Toggle available ↔ out_of_stock' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('itemId')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object, menu_dto_1.ToggleAvailabilityDto]),
    __metadata("design:returntype", void 0)
], MenuController.prototype, "toggle", null);
exports.MenuController = MenuController = __decorate([
    (0, swagger_1.ApiTags)('menu'),
    (0, common_1.Controller)('restaurants/:restaurantId'),
    __metadata("design:paramtypes", [menu_service_1.MenuService])
], MenuController);
//# sourceMappingURL=menu.controller.js.map