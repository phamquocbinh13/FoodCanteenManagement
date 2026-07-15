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
exports.CartStaffController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const cart_service_1 = require("./cart.service");
const cart_dto_1 = require("./dto/cart.dto");
let CartStaffController = class CartStaffController {
    cart;
    constructor(cart) {
        this.cart = cart;
    }
    get(restaurantId, sessionId) {
        return this.cart.getCart(restaurantId, sessionId);
    }
    add(restaurantId, sessionId, dto) {
        return this.cart.addItem(restaurantId, sessionId, dto);
    }
    patch(restaurantId, sessionId, id, dto) {
        return this.cart.patchItem(restaurantId, sessionId, id, dto);
    }
    putSelections(restaurantId, sessionId, id, dto) {
        return this.cart.putSelections(restaurantId, sessionId, id, dto);
    }
    remove(restaurantId, sessionId, id) {
        return this.cart.removeItem(restaurantId, sessionId, id);
    }
    clear(restaurantId, sessionId) {
        return this.cart.clearCart(restaurantId, sessionId);
    }
};
exports.CartStaffController = CartStaffController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: get session cart' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "get", null);
__decorate([
    (0, common_1.Post)('items'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: add cart item' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, cart_dto_1.AddCartItemDto]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "add", null);
__decorate([
    (0, common_1.Patch)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: patch cart item quantity' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Param)('id')),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, cart_dto_1.PatchCartItemDto]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "patch", null);
__decorate([
    (0, common_1.Put)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: replace cart item selections' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Param)('id')),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, cart_dto_1.PutCartItemSelectionsDto]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "putSelections", null);
__decorate([
    (0, common_1.Delete)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: remove cart item' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "remove", null);
__decorate([
    (0, common_1.Delete)(),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: clear cart' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], CartStaffController.prototype, "clear", null);
exports.CartStaffController = CartStaffController = __decorate([
    (0, swagger_1.ApiTags)('cart-staff'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, common_1.Controller)('restaurants/:restaurantId/sessions/:sessionId/cart'),
    __metadata("design:paramtypes", [cart_service_1.CartService])
], CartStaffController);
//# sourceMappingURL=cart.staff.controller.js.map