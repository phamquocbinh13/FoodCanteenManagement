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
exports.KitchenController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_user_decorator_1 = require("../auth/decorators/current-user.decorator");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const kitchen_service_1 = require("./kitchen.service");
let KitchenController = class KitchenController {
    kitchen;
    constructor(kitchen) {
        this.kitchen = kitchen;
    }
    queue(restaurantId) {
        return this.kitchen.getQueue(restaurantId);
    }
    complete(restaurantId, batchItemId, user) {
        return this.kitchen.completeBatchItem(restaurantId, batchItemId, user.sub);
    }
};
exports.KitchenController = KitchenController;
__decorate([
    (0, common_1.Get)('queue'),
    (0, swagger_1.ApiOperation)({
        summary: 'Kitchen queue — batches with items/tableLabel, no payment',
    }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], KitchenController.prototype, "queue", null);
__decorate([
    (0, common_1.Post)('items/:batchItemId/complete'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Mark batch item completed' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchItemId')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", void 0)
], KitchenController.prototype, "complete", null);
exports.KitchenController = KitchenController = __decorate([
    (0, swagger_1.ApiTags)('kitchen'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, common_1.Controller)('restaurants/:restaurantId/kitchen'),
    __metadata("design:paramtypes", [kitchen_service_1.KitchenService])
], KitchenController);
//# sourceMappingURL=kitchen.controller.js.map