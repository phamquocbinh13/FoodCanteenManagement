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
exports.CartCustomerController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_session_decorator_1 = require("../sessions/decorators/current-session.decorator");
const session_token_guard_1 = require("../sessions/guards/session-token.guard");
const cart_service_1 = require("./cart.service");
const cart_dto_1 = require("./dto/cart.dto");
let CartCustomerController = class CartCustomerController {
    cart;
    constructor(cart) {
        this.cart = cart;
    }
    get(ctx) {
        return this.cart.getCart(ctx.restaurantId, ctx.sessionId);
    }
    add(ctx, dto) {
        return this.cart.addItem(ctx.restaurantId, ctx.sessionId, dto);
    }
    patch(ctx, id, dto) {
        return this.cart.patchItem(ctx.restaurantId, ctx.sessionId, id, dto);
    }
    putSelections(ctx, id, dto) {
        return this.cart.putSelections(ctx.restaurantId, ctx.sessionId, id, dto);
    }
    remove(ctx, id) {
        return this.cart.removeItem(ctx.restaurantId, ctx.sessionId, id);
    }
    clear(ctx) {
        return this.cart.clearCart(ctx.restaurantId, ctx.sessionId);
    }
};
exports.CartCustomerController = CartCustomerController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get current session cart' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "get", null);
__decorate([
    (0, common_1.Post)('items'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Add item to cart' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, cart_dto_1.AddCartItemDto]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "add", null);
__decorate([
    (0, common_1.Patch)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Update cart item quantity' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, cart_dto_1.PatchCartItemDto]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "patch", null);
__decorate([
    (0, common_1.Put)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Replace cart item selections' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, cart_dto_1.PutCartItemSelectionsDto]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "putSelections", null);
__decorate([
    (0, common_1.Delete)('items/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Remove cart item' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "remove", null);
__decorate([
    (0, common_1.Delete)(),
    (0, swagger_1.ApiOperation)({ summary: 'Clear cart' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], CartCustomerController.prototype, "clear", null);
exports.CartCustomerController = CartCustomerController = __decorate([
    (0, swagger_1.ApiTags)('cart'),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, common_1.Controller)('sessions/me/cart'),
    __metadata("design:paramtypes", [cart_service_1.CartService])
], CartCustomerController);
//# sourceMappingURL=cart.customer.controller.js.map