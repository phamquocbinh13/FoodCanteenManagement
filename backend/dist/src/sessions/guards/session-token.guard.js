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
Object.defineProperty(exports, "__esModule", { value: true });
exports.SessionTokenGuard = void 0;
exports.extractSessionToken = extractSessionToken;
const common_1 = require("@nestjs/common");
const api_exception_1 = require("../../common/errors/api-exception");
const token_hash_1 = require("../../common/crypto/token-hash");
const prisma_service_1 = require("../../prisma/prisma.service");
let SessionTokenGuard = class SessionTokenGuard {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async canActivate(context) {
        const req = context.switchToHttp().getRequest();
        const token = extractSessionToken(req);
        if (!token) {
            throw (0, api_exception_1.unauthorized)('INVALID_SESSION_TOKEN', 'Session token required');
        }
        const tokenHash = (0, token_hash_1.sha256Hex)(token);
        const row = await this.prisma.session_auth_token.findUnique({
            where: { token_hash: tokenHash },
            include: { dine_in_session: true },
        });
        if (!row || row.revoked_at) {
            throw (0, api_exception_1.unauthorized)('INVALID_SESSION_TOKEN', 'Invalid session token');
        }
        if (row.expires_at.getTime() <= Date.now()) {
            throw (0, api_exception_1.unauthorized)('SESSION_TOKEN_EXPIRED', 'Session token expired');
        }
        req.customerSession = {
            sessionId: row.session_id,
            restaurantId: row.dine_in_session.restaurant_id,
            plaintextToken: token,
        };
        return true;
    }
};
exports.SessionTokenGuard = SessionTokenGuard;
exports.SessionTokenGuard = SessionTokenGuard = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SessionTokenGuard);
function extractSessionToken(req) {
    const header = req.header('x-session-token');
    if (header?.trim())
        return header.trim();
    const auth = req.header('authorization');
    if (auth?.toLowerCase().startsWith('bearer ')) {
        return auth.slice(7).trim() || null;
    }
    return null;
}
//# sourceMappingURL=session-token.guard.js.map