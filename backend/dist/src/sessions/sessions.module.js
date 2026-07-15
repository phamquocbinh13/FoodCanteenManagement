"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SessionsModule = void 0;
const common_1 = require("@nestjs/common");
const auth_module_1 = require("../auth/auth.module");
const restaurant_sessions_controller_1 = require("./restaurant-sessions.controller");
const session_token_guard_1 = require("./guards/session-token.guard");
const sessions_controller_1 = require("./sessions.controller");
const sessions_service_1 = require("./sessions.service");
let SessionsModule = class SessionsModule {
};
exports.SessionsModule = SessionsModule;
exports.SessionsModule = SessionsModule = __decorate([
    (0, common_1.Module)({
        imports: [auth_module_1.AuthModule],
        controllers: [sessions_controller_1.SessionsController, restaurant_sessions_controller_1.RestaurantSessionsController],
        providers: [sessions_service_1.SessionsService, session_token_guard_1.SessionTokenGuard],
        exports: [sessions_service_1.SessionsService, session_token_guard_1.SessionTokenGuard],
    })
], SessionsModule);
//# sourceMappingURL=sessions.module.js.map