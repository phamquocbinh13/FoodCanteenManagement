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
exports.SettingsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SettingsService = class SettingsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getSettings(restaurantId) {
        const settings = await this.prisma.restaurantSettings.findUnique({
            where: { restaurantId }
        });
        if (!settings)
            throw new common_1.NotFoundException('Settings not found');
        return settings;
    }
    async updateSettings(restaurantId, data) {
        return this.prisma.restaurantSettings.update({
            where: { restaurantId },
            data: {
                defaultCurrency: data.defaultCurrency,
                taxRateBps: data.taxRateBps,
                serviceChargeBps: data.serviceChargeBps,
                sessionTokenTtlMinutes: data.sessionTokenTtlMinutes,
                allowQrOnReservedTable: data.allowQrOnReservedTable,
                paymentSoftLockEnabled: data.paymentSoftLockEnabled,
            }
        });
    }
};
exports.SettingsService = SettingsService;
exports.SettingsService = SettingsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SettingsService);
//# sourceMappingURL=settings.service.js.map