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
exports.BatchesStaffController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const batches_service_1 = require("./batches.service");
const batches_dto_1 = require("./dto/batches.dto");
let BatchesStaffController = class BatchesStaffController {
    batches;
    constructor(batches) {
        this.batches = batches;
    }
    confirm(restaurantId, sessionId, dto) {
        return this.batches.confirmFromCart(restaurantId, sessionId, {
            ...dto,
            actorType: dto.actorType ?? 'user',
        });
    }
    listSession(restaurantId, sessionId) {
        return this.batches.listSessionBatches(restaurantId, sessionId);
    }
    createBatch(restaurantId, sessionId, dto) {
        return this.batches.createBatch(restaurantId, sessionId, dto);
    }
    createItem(restaurantId, batchId, dto) {
        return this.batches.createBatchItem(restaurantId, batchId, dto);
    }
    createCustomizations(restaurantId, batchItemId, dto) {
        return this.batches.createCustomizations(restaurantId, batchItemId, dto);
    }
    getBatch(restaurantId, batchId) {
        return this.batches.getBatch(restaurantId, batchId);
    }
    updateItemQuantity(restaurantId, batchItemId, dto) {
        return this.batches.updateItemQuantity(restaurantId, batchItemId, dto.delta);
    }
    deleteItem(restaurantId, batchItemId) {
        return this.batches.deleteItem(restaurantId, batchItemId);
    }
};
exports.BatchesStaffController = BatchesStaffController;
__decorate([
    (0, common_1.Post)('sessions/:sessionId/batches/confirm'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Staff: confirm session cart to batch' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, batches_dto_1.ConfirmBatchDto]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "confirm", null);
__decorate([
    (0, common_1.Get)('sessions/:sessionId/batches'),
    (0, swagger_1.ApiOperation)({ summary: 'List batches for session' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "listSession", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/batches'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Create KitchenBatch entity' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, batches_dto_1.CreateBatchDto]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "createBatch", null);
__decorate([
    (0, common_1.Post)('batches/:batchId/items'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Create batch item' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, batches_dto_1.CreateBatchItemDto]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "createItem", null);
__decorate([
    (0, common_1.Post)('batch-items/:batchItemId/customizations'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Bulk create batch item customizations' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchItemId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, batches_dto_1.BulkCustomizationsDto]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "createCustomizations", null);
__decorate([
    (0, common_1.Get)('batches/:batchId'),
    (0, swagger_1.ApiOperation)({ summary: 'Get batch ticket by id' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "getBatch", null);
__decorate([
    (0, common_1.Patch)('batch-items/:batchItemId/quantity'),
    (0, swagger_1.ApiOperation)({ summary: 'Update batch item quantity' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchItemId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, batches_dto_1.UpdateBatchItemQuantityDto]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "updateItemQuantity", null);
__decorate([
    (0, common_1.Delete)('batch-items/:batchItemId'),
    (0, common_1.HttpCode)(common_1.HttpStatus.NO_CONTENT),
    (0, swagger_1.ApiOperation)({ summary: 'Delete batch item' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('batchItemId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], BatchesStaffController.prototype, "deleteItem", null);
exports.BatchesStaffController = BatchesStaffController = __decorate([
    (0, swagger_1.ApiTags)('batches-staff'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, common_1.Controller)('restaurants/:restaurantId'),
    __metadata("design:paramtypes", [batches_service_1.BatchesService])
], BatchesStaffController);
//# sourceMappingURL=batches.staff.controller.js.map