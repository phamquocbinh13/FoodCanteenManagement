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
exports.AnalyticsController = void 0;
const common_1 = require("@nestjs/common");
const analytics_service_1 = require("./analytics.service");
let AnalyticsController = class AnalyticsController {
    analyticsService;
    constructor(analyticsService) {
        this.analyticsService = analyticsService;
    }
    async getVelocity(restaurantId) {
        if (!restaurantId)
            throw new common_1.UnauthorizedException('Missing restaurant ID');
        return this.analyticsService.getVelocity(restaurantId);
    }
    async getInsights() {
        return this.analyticsService.getInsights();
    }
    async getRevenue(restaurantId) {
        if (!restaurantId)
            throw new common_1.UnauthorizedException('Missing restaurant ID');
        return this.analyticsService.getRevenue(restaurantId);
    }
    async getHeatmap(restaurantId) {
        if (!restaurantId)
            throw new common_1.UnauthorizedException('Missing restaurant ID');
        return this.analyticsService.getHeatmap(restaurantId);
    }
    async getKpis(restaurantId) {
        if (!restaurantId)
            throw new common_1.UnauthorizedException('Missing restaurant ID');
        return this.analyticsService.getKpis(restaurantId);
    }
};
exports.AnalyticsController = AnalyticsController;
__decorate([
    (0, common_1.Get)('velocity'),
    __param(0, (0, common_1.Headers)('x-restaurant-id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AnalyticsController.prototype, "getVelocity", null);
__decorate([
    (0, common_1.Get)('insights'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AnalyticsController.prototype, "getInsights", null);
__decorate([
    (0, common_1.Get)('revenue'),
    __param(0, (0, common_1.Headers)('x-restaurant-id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AnalyticsController.prototype, "getRevenue", null);
__decorate([
    (0, common_1.Get)('heatmap'),
    __param(0, (0, common_1.Headers)('x-restaurant-id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AnalyticsController.prototype, "getHeatmap", null);
__decorate([
    (0, common_1.Get)('kpis'),
    __param(0, (0, common_1.Headers)('x-restaurant-id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AnalyticsController.prototype, "getKpis", null);
exports.AnalyticsController = AnalyticsController = __decorate([
    (0, common_1.Controller)('analytics'),
    __metadata("design:paramtypes", [analytics_service_1.AnalyticsService])
], AnalyticsController);
//# sourceMappingURL=analytics.controller.js.map