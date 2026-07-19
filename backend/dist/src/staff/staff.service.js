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
exports.StaffService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const argon2 = __importStar(require("argon2"));
const uuid_1 = require("uuid");
let StaffService = class StaffService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    _mapToSnakeCase(user) {
        if (!user)
            return null;
        return {
            id: user.id,
            restaurant_id: user.restaurantId,
            email: user.email,
            display_name: user.displayName,
            password_hash: user.passwordHash,
            is_active: user.isActive,
            created_at: user.createdAt,
            updated_at: user.updatedAt,
            roles: user.user_role?.map((ur) => ({
                id: ur.role.id,
                key: ur.role.roleKey,
                name: ur.role.name,
                created_at: ur.role.createdAt
            })) || []
        };
    }
    async findAll(restaurantId) {
        const users = await this.prisma.staffUser.findMany({
            where: { restaurantId },
            include: { user_role: { include: { role: true } } },
            orderBy: { displayName: 'asc' },
        });
        return users.map(u => this._mapToSnakeCase(u));
    }
    async findOne(restaurantId, id) {
        const user = await this.prisma.staffUser.findFirst({
            where: { id, restaurantId },
            include: { user_role: { include: { role: true } } },
        });
        if (!user)
            throw new common_1.NotFoundException('Staff not found');
        return this._mapToSnakeCase(user);
    }
    async create(restaurantId, data) {
        const passwordHash = await argon2.hash(data.password || data.password_hash || 'changeme123');
        const user = await this.prisma.staffUser.create({
            data: {
                id: (0, uuid_1.v4)(),
                restaurantId,
                email: data.email,
                displayName: data.displayName || data.display_name,
                passwordHash,
                isActive: data.isActive ?? data.is_active ?? true,
            },
            include: { user_role: { include: { role: true } } },
        });
        return this._mapToSnakeCase(user);
    }
    async update(restaurantId, id, data) {
        await this.findOne(restaurantId, id);
        const updateData = {
            email: data.email,
            displayName: data.displayName || data.display_name,
            isActive: data.isActive ?? data.is_active,
        };
        if (data.password || data.password_hash) {
            updateData.passwordHash = await argon2.hash(data.password || data.password_hash);
        }
        const user = await this.prisma.staffUser.update({
            where: { id },
            data: updateData,
            include: { user_role: { include: { role: true } } },
        });
        return this._mapToSnakeCase(user);
    }
    async remove(restaurantId, id) {
        await this.findOne(restaurantId, id);
        const user = await this.prisma.staffUser.update({
            where: { id },
            data: { isActive: false },
        });
        return this._mapToSnakeCase(user);
    }
};
exports.StaffService = StaffService;
exports.StaffService = StaffService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], StaffService);
//# sourceMappingURL=staff.service.js.map