"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const jwt_1 = require("@nestjs/jwt");
const argon2 = __importStar(require("argon2"));
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const token_hash_1 = require("../common/crypto/token-hash");
const duration_1 = require("../common/utils/duration");
const prisma_service_1 = require("../prisma/prisma.service");
const auth_types_1 = require("./auth.types");
let AuthService = class AuthService {
    prisma;
    jwt;
    config;
    accessTtlMs;
    refreshTtlMs;
    constructor(prisma, jwt, config) {
        this.prisma = prisma;
        this.jwt = jwt;
        this.config = config;
        this.accessTtlMs = (0, duration_1.parseDurationMs)(this.config.get('JWT_ACCESS_TTL'), 15 * 60_000);
        this.refreshTtlMs = (0, duration_1.parseDurationMs)(this.config.get('JWT_REFRESH_TTL'), 7 * 86_400_000);
    }
    async login(username, password) {
        const email = (0, auth_types_1.resolveLoginEmail)(username);
        const user = await this.findStaffByEmail(email);
        if (!user) {
            throw (0, api_exception_1.unauthorized)('INVALID_CREDENTIALS', 'Invalid username or password');
        }
        if (!user.isActive) {
            throw (0, api_exception_1.forbidden)('USER_INACTIVE', 'User account is inactive');
        }
        const ok = await this.verifyPassword(user.passwordHash, password);
        if (!ok) {
            throw (0, api_exception_1.unauthorized)('INVALID_CREDENTIALS', 'Invalid username or password');
        }
        await this.prisma.staffUser.update({
            where: { id: user.id },
            data: { lastLoginAt: new Date() },
        });
        return this.issueTokens(user);
    }
    async refresh(refreshToken) {
        const tokenHash = (0, token_hash_1.sha256Hex)(refreshToken);
        const stored = await this.prisma.staff_refresh_token.findUnique({
            where: { token_hash: tokenHash },
        });
        if (!stored || stored.revoked_at) {
            throw (0, api_exception_1.unauthorized)('INVALID_REFRESH', 'Invalid refresh token');
        }
        if (stored.expires_at.getTime() <= Date.now()) {
            throw (0, api_exception_1.unauthorized)('REFRESH_EXPIRED', 'Refresh token expired');
        }
        const user = await this.findStaffById(stored.user_id);
        if (!user || !user.isActive) {
            throw (0, api_exception_1.unauthorized)('INVALID_REFRESH', 'Invalid refresh token');
        }
        await this.prisma.staff_refresh_token.update({
            where: { id: stored.id },
            data: { revoked_at: new Date() },
        });
        return this.issueTokens(user);
    }
    async logout(refreshToken) {
        if (!refreshToken)
            return;
        const tokenHash = (0, token_hash_1.sha256Hex)(refreshToken);
        await this.prisma.staff_refresh_token.updateMany({
            where: { token_hash: tokenHash, revoked_at: null },
            data: { revoked_at: new Date() },
        });
    }
    async me(userId) {
        const user = await this.findStaffById(userId);
        if (!user) {
            throw (0, api_exception_1.unauthorized)('UNAUTHORIZED', 'Not authenticated');
        }
        return this.toUserDto(user);
    }
    async issueTokens(user) {
        const role = user.user_role[0]?.role.roleKey ?? 'cashier';
        const payload = {
            sub: user.id,
            email: user.email,
            role,
            rid: user.restaurantId,
        };
        const expiresAt = new Date(Date.now() + this.accessTtlMs);
        const accessToken = await this.jwt.signAsync(payload, {
            expiresIn: Math.floor(this.accessTtlMs / 1000),
            algorithm: 'HS256',
        });
        const refreshToken = (0, token_hash_1.generateOpaqueToken)(48);
        const refreshExpires = new Date(Date.now() + this.refreshTtlMs);
        await this.prisma.staff_refresh_token.create({
            data: {
                id: (0, uuid_1.v4)(),
                user_id: user.id,
                restaurant_id: user.restaurantId,
                token_hash: (0, token_hash_1.sha256Hex)(refreshToken),
                expires_at: refreshExpires,
            },
        });
        return {
            user: this.toUserDto(user),
            accessToken,
            refreshToken,
            expiresAt: expiresAt.toISOString(),
        };
    }
    toUserDto(user) {
        return {
            id: user.id,
            username: (0, auth_types_1.usernameFromEmail)(user.email),
            fullName: user.displayName,
            role: user.user_role[0]?.role.roleKey ?? 'cashier',
            permissions: [],
            active: user.isActive,
            createdAt: user.createdAt.toISOString(),
        };
    }
    async findStaffByEmail(email) {
        return this.prisma.staffUser.findFirst({
            where: { email },
            include: { user_role: { include: { role: true } } },
        });
    }
    async findStaffById(id) {
        return this.prisma.staffUser.findUnique({
            where: { id },
            include: { user_role: { include: { role: true } } },
        });
    }
    async verifyPassword(passwordHash, password) {
        if (passwordHash.startsWith('$REPLACE_WITH_ARGON2_')) {
            return false;
        }
        try {
            return await argon2.verify(passwordHash, password);
        }
        catch {
            return false;
        }
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        jwt_1.JwtService,
        config_1.ConfigService])
], AuthService);
//# sourceMappingURL=auth.service.js.map