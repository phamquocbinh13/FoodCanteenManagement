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
exports.BatchesCustomerController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_session_decorator_1 = require("../sessions/decorators/current-session.decorator");
const session_token_guard_1 = require("../sessions/guards/session-token.guard");
const batches_service_1 = require("./batches.service");
const batches_dto_1 = require("./dto/batches.dto");
let BatchesCustomerController = class BatchesCustomerController {
    batches;
    constructor(batches) {
        this.batches = batches;
    }
    confirm(ctx, dto) {
        return this.batches.confirmFromCart(ctx.restaurantId, ctx.sessionId, dto);
    }
    progress(ctx) {
        return this.batches.getProgress(ctx.restaurantId, ctx.sessionId);
    }
};
exports.BatchesCustomerController = BatchesCustomerController;
__decorate([
    (0, common_1.Post)(),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Confirm cart → kitchen batch ticket' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, batches_dto_1.ConfirmBatchDto]),
    __metadata("design:returntype", void 0)
], BatchesCustomerController.prototype, "confirm", null);
__decorate([
    (0, common_1.Get)('progress'),
    (0, swagger_1.ApiOperation)({ summary: 'Customer batch progress (no item detail)' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], BatchesCustomerController.prototype, "progress", null);
exports.BatchesCustomerController = BatchesCustomerController = __decorate([
    (0, swagger_1.ApiTags)('batches'),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, common_1.Controller)('sessions/me/batches'),
    __metadata("design:paramtypes", [batches_service_1.BatchesService])
], BatchesCustomerController);
//# sourceMappingURL=batches.customer.controller.js.map