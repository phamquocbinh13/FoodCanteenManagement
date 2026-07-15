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
exports.RequestsService = void 0;
const common_1 = require("@nestjs/common");
const uuid_1 = require("uuid");
const api_exception_1 = require("../common/errors/api-exception");
const prisma_service_1 = require("../prisma/prisma.service");
const requests_mapper_1 = require("./requests.mapper");
let RequestsService = class RequestsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(restaurantId, sessionId, dto) {
        const session = await this.requireOpenSession(restaurantId, sessionId);
        const now = new Date();
        const created = await this.prisma.$transaction(async (tx) => {
            const row = await tx.staff_request.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    restaurant_id: restaurantId,
                    session_id: sessionId,
                    request_type: dto.requestType,
                    status: 'pending',
                    note: dto.note?.trim() || null,
                    requested_at: now,
                    created_at: now,
                },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: sessionId,
                    event_type: dto.requestType === 'payment'
                        ? 'payment_requested'
                        : 'staff_request_created',
                    payload_json: {
                        requestId: row.id,
                        requestType: dto.requestType,
                    },
                    actor_type: 'customer_session',
                    actor_id: null,
                    occurred_at: now,
                },
            });
            if (dto.requestType === 'payment' && session.status === 'open') {
                await tx.dine_in_session.update({
                    where: { id: sessionId },
                    data: {
                        status: 'payment_pending',
                        payment_status: 'waiting_payment',
                        updated_at: now,
                    },
                });
            }
            return row;
        });
        return (0, requests_mapper_1.mapStaffRequest)(created);
    }
    async listForSession(restaurantId, sessionId) {
        await this.requireSession(restaurantId, sessionId);
        const rows = await this.prisma.staff_request.findMany({
            where: { restaurant_id: restaurantId, session_id: sessionId },
            orderBy: { requested_at: 'desc' },
        });
        return { requests: rows.map(requests_mapper_1.mapStaffRequest) };
    }
    async listPending(restaurantId) {
        const restaurant = await this.prisma.restaurant.findUnique({
            where: { id: restaurantId },
        });
        if (!restaurant) {
            throw (0, api_exception_1.notFound)('RESTAURANT_NOT_FOUND', 'Restaurant not found');
        }
        const rows = await this.prisma.staff_request.findMany({
            where: { restaurant_id: restaurantId, status: 'pending' },
            orderBy: { requested_at: 'asc' },
        });
        return { requests: rows.map(requests_mapper_1.mapStaffRequest) };
    }
    async handle(restaurantId, requestId, dto, actorUserId) {
        const row = await this.prisma.staff_request.findFirst({
            where: { id: requestId, restaurant_id: restaurantId },
        });
        if (!row) {
            throw (0, api_exception_1.notFound)('REQUEST_NOT_FOUND', 'Staff request not found');
        }
        if (row.status !== 'pending') {
            throw (0, api_exception_1.conflict)('REQUEST_ALREADY_HANDLED', 'Request is not pending');
        }
        const handledBy = dto.handledByUserId ?? actorUserId;
        const now = new Date();
        const updated = await this.prisma.$transaction(async (tx) => {
            const next = await tx.staff_request.update({
                where: { id: requestId },
                data: {
                    status: 'handled',
                    handled_at: now,
                    handled_by_user_id: handledBy,
                },
            });
            await tx.session_timeline_event.create({
                data: {
                    id: (0, uuid_1.v4)(),
                    session_id: row.session_id,
                    event_type: 'staff_request_handled',
                    payload_json: {
                        requestId,
                        requestType: row.request_type,
                    },
                    actor_type: 'user',
                    actor_id: handledBy,
                    occurred_at: now,
                },
            });
            return next;
        });
        return (0, requests_mapper_1.mapStaffRequest)(updated);
    }
    async requireSession(restaurantId, sessionId) {
        const session = await this.prisma.dine_in_session.findFirst({
            where: { id: sessionId, restaurant_id: restaurantId },
        });
        if (!session) {
            throw (0, api_exception_1.notFound)('SESSION_NOT_FOUND', 'Session not found');
        }
        return session;
    }
    async requireOpenSession(restaurantId, sessionId) {
        const session = await this.requireSession(restaurantId, sessionId);
        if (session.status === 'closed') {
            throw (0, api_exception_1.unprocessable)('SESSION_CLOSED', 'Session is closed');
        }
        return session;
    }
};
exports.RequestsService = RequestsService;
exports.RequestsService = RequestsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], RequestsService);
//# sourceMappingURL=requests.service.js.map