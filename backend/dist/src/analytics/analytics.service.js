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
var AnalyticsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnalyticsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AnalyticsService = AnalyticsService_1 = class AnalyticsService {
    prisma;
    logger = new common_1.Logger(AnalyticsService_1.name);
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getVelocity(restaurantId) {
        const result = await this.prisma.batch_item.groupBy({
            by: ['menu_item_id'],
            _sum: {
                quantity: true,
            },
            where: {
                restaurant_id: restaurantId,
            },
            orderBy: {
                _sum: {
                    quantity: 'desc'
                }
            }
        });
        const menuIds = result.map(r => r.menu_item_id);
        const menuItems = await this.prisma.menuItem.findMany({
            where: { id: { in: menuIds } }
        });
        const map = new Map(menuItems.map(m => [m.id, m]));
        const aggregated = result.map(r => {
            const item = map.get(r.menu_item_id);
            return {
                id: item?.id,
                name: item?.name,
                image_url: item?.imageUrl,
                quantity_sold: r._sum.quantity || 0,
                currency_code: item?.currencyCode,
                base_price_minor: Number(item?.basePriceMinor || 0)
            };
        });
        const best_sellers = aggregated.slice(0, 3);
        const worst_sellers = aggregated.slice().reverse().slice(0, 3);
        return { best_sellers, worst_sellers };
    }
    async getInsights() {
        try {
            const url = 'https://api.open-meteo.com/v1/forecast?latitude=10.823&longitude=106.6296&current_weather=true&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=Asia%2FBangkok';
            const response = await fetch(url);
            const data = await response.json();
            const weatherCode = data.current_weather?.weathercode || 0;
            const isRaining = weatherCode >= 50;
            const insights = [];
            if (isRaining) {
                insights.push("Rain expected. Pre-prep warm selections (soups, hot drinks) by +15%.");
            }
            else {
                insights.push("Clear weather. Cold beverages demand expected to rise.");
            }
            insights.push("Inventory Tracking active. All standard stocks appear safe.");
            const forecastDays = [];
            if (data.daily && data.daily.time) {
                for (let i = 0; i < data.daily.time.length; i++) {
                    forecastDays.push({
                        date: data.daily.time[i],
                        weather_code: data.daily.weathercode[i],
                        temp_max: Math.round(data.daily.temperature_2m_max[i]),
                        temp_min: Math.round(data.daily.temperature_2m_min[i])
                    });
                }
            }
            return { alerts: insights, forecast_days: forecastDays };
        }
        catch (e) {
            this.logger.error('Failed to fetch weather', e);
            return { alerts: ["Unable to fetch external insights at this time."], forecast_days: [] };
        }
    }
    async getRevenue(restaurantId) {
        const result = await this.prisma.$queryRaw `
      SELECT DATE(closed_at) as date, SUM(payment_total_minor) as revenue
      FROM dine_in_session
      WHERE restaurant_id = ${restaurantId} AND payment_status = 'paid' AND closed_at IS NOT NULL
      GROUP BY DATE(closed_at)
      ORDER BY date ASC
      LIMIT 14
    `;
        return result.map(r => ({
            date: r.date.toISOString().split('T')[0],
            revenue_minor: Number(r.revenue || 0)
        }));
    }
    async getHeatmap(restaurantId) {
        const result = await this.prisma.$queryRaw `
      SELECT HOUR(opened_at) as hour, COUNT(*) as count
      FROM dine_in_session
      WHERE restaurant_id = ${restaurantId}
      GROUP BY HOUR(opened_at)
      ORDER BY hour ASC
    `;
        return result.map(r => ({
            hour: Number(r.hour),
            intensity: Number(r.count)
        }));
    }
    async getKpis(restaurantId) {
        const sessions = await this.prisma.dine_in_session.aggregate({
            _count: { id: true },
            _sum: { payment_total_minor: true },
            where: { restaurant_id: restaurantId, payment_status: 'paid' }
        });
        const totalSessions = sessions._count.id || 0;
        const totalRevenue = Number(sessions._sum.payment_total_minor || 0);
        const averageOrderValueMinor = totalSessions > 0 ? Math.floor(totalRevenue / totalSessions) : 0;
        const payments = await this.prisma.session_payment.groupBy({
            by: ['payment_method'],
            _sum: { total_amount_minor: true },
            where: { dine_in_session: { restaurant_id: restaurantId } }
        });
        const paymentMethods = payments.map(p => ({
            method: p.payment_method,
            total_minor: Number(p._sum.total_amount_minor || 0)
        }));
        return {
            average_order_value_minor: averageOrderValueMinor,
            total_sessions: totalSessions,
            total_revenue_minor: totalRevenue,
            payment_methods: paymentMethods
        };
    }
};
exports.AnalyticsService = AnalyticsService;
exports.AnalyticsService = AnalyticsService = AnalyticsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AnalyticsService);
//# sourceMappingURL=analytics.service.js.map