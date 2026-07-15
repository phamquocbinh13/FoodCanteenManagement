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
exports.RestaurantSessionsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_user_decorator_1 = require("../auth/decorators/current-user.decorator");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const restaurant_scope_guard_1 = require("../auth/guards/restaurant-scope.guard");
const sessions_dto_1 = require("./dto/sessions.dto");
const sessions_service_1 = require("./sessions.service");
let RestaurantSessionsController = class RestaurantSessionsController {
    sessions;
    constructor(sessions) {
        this.sessions = sessions;
    }
    create(restaurantId, user, dto) {
        return this.sessions.create(restaurantId, user.sub, dto);
    }
    listActive(restaurantId) {
        return this.sessions.listActive(restaurantId);
    }
    nextDailySequence(restaurantId, dateKey) {
        return this.sessions.nextDailySequence(restaurantId, dateKey);
    }
    findById(restaurantId, sessionId) {
        return this.sessions.findById(restaurantId, sessionId);
    }
    findByTable(restaurantId, tableId) {
        return this.sessions.findActiveByTable(restaurantId, tableId);
    }
    waitingPayment(restaurantId, sessionId) {
        return this.sessions.markWaitingPayment(restaurantId, sessionId);
    }
    reissueToken(restaurantId, sessionId) {
        return this.sessions.reissueToken(restaurantId, sessionId);
    }
    close(restaurantId, sessionId, user, dto) {
        return this.sessions.close(restaurantId, sessionId, dto.closedByUserId ?? user.sub);
    }
    transfer(_restaurantId, _sessionId, _dto) {
        return this.sessions.transfer();
    }
    update(restaurantId, sessionId, dto) {
        return this.sessions.update(restaurantId, sessionId, dto);
    }
    appendTimeline(restaurantId, sessionId, user, dto) {
        return this.sessions.appendTimeline(restaurantId, sessionId, dto, user.sub);
    }
    nextBatchNumber(restaurantId, sessionId) {
        return this.sessions.nextBatchNumber(restaurantId, sessionId);
    }
    bill(restaurantId, sessionId) {
        return this.sessions.getBill(restaurantId, sessionId);
    }
};
exports.RestaurantSessionsController = RestaurantSessionsController;
__decorate([
    (0, common_1.Post)('sessions'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Create dine-in session (Stage A)' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, current_user_decorator_1.CurrentUser)()),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object, sessions_dto_1.CreateSessionDto]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('sessions/active'),
    (0, swagger_1.ApiOperation)({ summary: 'List active sessions for restaurant' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "listActive", null);
__decorate([
    (0, common_1.Get)('sessions/next-daily-sequence'),
    (0, swagger_1.ApiOperation)({ summary: 'Allocate next daily session sequence' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Query)('dateKey')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "nextDailySequence", null);
__decorate([
    (0, common_1.Get)('sessions/:sessionId'),
    (0, swagger_1.ApiOperation)({ summary: 'Get session by id' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "findById", null);
__decorate([
    (0, common_1.Get)('tables/:tableId/session'),
    (0, swagger_1.ApiOperation)({ summary: 'Find active session for table' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('tableId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "findByTable", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/waiting-payment'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Mark session waiting payment' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "waitingPayment", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/reissue-token'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Revoke active session token and issue a new one' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "reissueToken", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/close'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Close session and free table' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object, sessions_dto_1.CloseSessionDto]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "close", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/transfer'),
    (0, swagger_1.ApiOperation)({ summary: 'Transfer session (501 until Phase 2)' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, sessions_dto_1.TransferSessionDto]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "transfer", null);
__decorate([
    (0, common_1.Patch)('sessions/:sessionId'),
    (0, swagger_1.ApiOperation)({ summary: 'Update session payment summary / batch number' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, sessions_dto_1.UpdateSessionDto]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "update", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/timeline'),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    (0, swagger_1.ApiOperation)({ summary: 'Append session timeline event' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __param(2, (0, current_user_decorator_1.CurrentUser)()),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object, sessions_dto_1.AppendTimelineDto]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "appendTimeline", null);
__decorate([
    (0, common_1.Post)('sessions/:sessionId/next-batch-number'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Increment and return next batch number' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "nextBatchNumber", null);
__decorate([
    (0, common_1.Get)('sessions/:sessionId/bill'),
    (0, swagger_1.ApiOperation)({ summary: 'Get session payment summary (bill)' }),
    __param(0, (0, common_1.Param)('restaurantId')),
    __param(1, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], RestaurantSessionsController.prototype, "bill", null);
exports.RestaurantSessionsController = RestaurantSessionsController = __decorate([
    (0, swagger_1.ApiTags)('restaurant-sessions'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, restaurant_scope_guard_1.RestaurantScopeGuard),
    (0, common_1.Controller)('restaurants/:restaurantId'),
    __metadata("design:paramtypes", [sessions_service_1.SessionsService])
], RestaurantSessionsController);
//# sourceMappingURL=restaurant-sessions.controller.js.map