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
exports.RequestsCustomerController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_session_decorator_1 = require("../sessions/decorators/current-session.decorator");
const session_token_guard_1 = require("../sessions/guards/session-token.guard");
const requests_dto_1 = require("./dto/requests.dto");
const requests_service_1 = require("./requests.service");
let RequestsCustomerController = class RequestsCustomerController {
    requests;
    constructor(requests) {
        this.requests = requests;
    }
    create(ctx, dto) {
        return this.requests.create(ctx.restaurantId, ctx.sessionId, dto);
    }
    list(ctx) {
        return this.requests.listForSession(ctx.restaurantId, ctx.sessionId);
    }
};
exports.RequestsCustomerController = RequestsCustomerController;
__decorate([
    (0, common_1.Post)(),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Create staff request' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, requests_dto_1.CreateStaffRequestDto]),
    __metadata("design:returntype", void 0)
], RequestsCustomerController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'List requests for current session' }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], RequestsCustomerController.prototype, "list", null);
exports.RequestsCustomerController = RequestsCustomerController = __decorate([
    (0, swagger_1.ApiTags)('requests'),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, common_1.Controller)('sessions/me/requests'),
    __metadata("design:paramtypes", [requests_service_1.RequestsService])
], RequestsCustomerController);
//# sourceMappingURL=requests.customer.controller.js.map