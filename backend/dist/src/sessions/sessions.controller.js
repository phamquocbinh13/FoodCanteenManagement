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
exports.SessionsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const current_session_decorator_1 = require("./decorators/current-session.decorator");
const sessions_dto_1 = require("./dto/sessions.dto");
const session_token_guard_1 = require("./guards/session-token.guard");
const sessions_service_1 = require("./sessions.service");
let SessionsController = class SessionsController {
    sessions;
    constructor(sessions) {
        this.sessions = sessions;
    }
    join(dto) {
        return this.sessions.join(dto.sessionToken, dto.deviceId);
    }
    me(ctx) {
        return this.sessions.me(ctx.plaintextToken);
    }
};
exports.SessionsController = SessionsController;
__decorate([
    (0, common_1.Post)('join'),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    (0, swagger_1.ApiOperation)({ summary: 'Join session by token (B2 / customer)' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [sessions_dto_1.JoinSessionDto]),
    __metadata("design:returntype", void 0)
], SessionsController.prototype, "join", null);
__decorate([
    (0, common_1.Get)('me'),
    (0, common_1.UseGuards)(session_token_guard_1.SessionTokenGuard),
    (0, swagger_1.ApiHeader)({ name: 'X-Session-Token', required: false }),
    (0, swagger_1.ApiOperation)({
        summary: 'Validate customer session token (Bearer or X-Session-Token)',
    }),
    __param(0, (0, current_session_decorator_1.CurrentSession)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], SessionsController.prototype, "me", null);
exports.SessionsController = SessionsController = __decorate([
    (0, swagger_1.ApiTags)('sessions'),
    (0, common_1.Controller)('sessions'),
    __metadata("design:paramtypes", [sessions_service_1.SessionsService])
], SessionsController);
//# sourceMappingURL=sessions.controller.js.map