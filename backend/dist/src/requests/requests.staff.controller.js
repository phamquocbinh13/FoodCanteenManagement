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
exports.RequestsStaffController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_user_decorator_1 = require("../auth/decorators/current-user.decorator");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const requests_dto_1 = require("./dto/requests.dto");
const requests_service_1 = require("./requests.service");
let RequestsStaffController = class RequestsStaffController {
    requests;
    constructor(requests) {
        this.requests = requests;
    }
    pending(restaurantId) {
        return this.requests.listPending(restaurantId);
    }
    listSession(restaurantId, sessionId) {
        return this.requests.listForSession(restaurantId, sessionId);
    }
    handle(restaurantId, requestId, user, dto) {
        return this.requests.handle(restaurantId, requestId, dto, user.sub);
    }
};
exports.RequestsStaffController = RequestsStaffController;
__decorate([
    (0, common_1.Get)('requests/pending'),
    (0, swagger_1.ApiOperation)({ summary: 'Pending staff requests queue' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], RequestsStaffController.prototype, "pending", null);
__decorate([
    (0, common_1.Get)('sessions/:sessionId/requests'),
    (0, swagger_1.ApiOperation)({ summary: 'List requests for a session' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RequestsStaffController.prototype, "listSession", null);
__decorate([
    (0, common_1.Post)('requests/:requestId/handle'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Mark staff request handled' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('requestId')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object, requests_dto_1.HandleStaffRequestDto]),
    __metadata("design:returntype", void 0)
], RequestsStaffController.prototype, "handle", null);
exports.RequestsStaffController = RequestsStaffController = __decorate([
    (0, swagger_1.ApiTags)('requests-staff'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, common_1.Controller)('restaurants/:restaurantId'),
    __metadata("design:paramtypes", [requests_service_1.RequestsService])
], RequestsStaffController);
//# sourceMappingURL=requests.staff.controller.js.map