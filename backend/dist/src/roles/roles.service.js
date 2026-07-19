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
exports.RolesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const uuid_1 = require("uuid");
let RolesService = class RolesService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll() {
        const roles = await this.prisma.role.findMany({
            orderBy: { name: 'asc' },
        });
        return roles.map(r => ({
            id: r.id,
            key: r.roleKey,
            name: r.name,
            created_at: r.createdAt
        }));
    }
    async assignRoles(restaurantId, userId, roleIds) {
        const user = await this.prisma.staffUser.findFirst({
            where: { id: userId, restaurantId }
        });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        await this.prisma.user_role.deleteMany({
            where: { user_id: userId }
        });
        if (roleIds.length > 0) {
            const inserts = roleIds.map(roleId => ({
                id: (0, uuid_1.v4)(),
                user_id: userId,
                role_id: roleId,
            }));
            await this.prisma.user_role.createMany({
                data: inserts
            });
        }
        return { success: true };
    }
};
exports.RolesService = RolesService;
exports.RolesService = RolesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], RolesService);
//# sourceMappingURL=roles.service.js.map