import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import {
  conflict,
  notFound,
  unprocessable,
} from '../common/errors/api-exception';
import { PrismaService } from '../prisma/prisma.service';
import { CreateStaffRequestDto, HandleStaffRequestDto } from './dto/requests.dto';
import { mapStaffRequest, type StaffRequestDto } from './requests.mapper';

@Injectable()
export class RequestsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(
    restaurantId: string,
    sessionId: string,
    dto: CreateStaffRequestDto,
  ): Promise<StaffRequestDto> {
    const session = await this.requireOpenSession(restaurantId, sessionId);
    const now = new Date();

    const created = await this.prisma.$transaction(async (tx) => {
      const row = await tx.staff_request.create({
        data: {
          id: uuidv4(),
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
          id: uuidv4(),
          session_id: sessionId,
          event_type:
            dto.requestType === 'payment'
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

    return mapStaffRequest(created);
  }

  async listForSession(
    restaurantId: string,
    sessionId: string,
  ): Promise<{ requests: StaffRequestDto[] }> {
    await this.requireSession(restaurantId, sessionId);
    const rows = await this.prisma.staff_request.findMany({
      where: { restaurant_id: restaurantId, session_id: sessionId },
      orderBy: { requested_at: 'desc' },
    });
    return { requests: rows.map(mapStaffRequest) };
  }

  async listPending(
    restaurantId: string,
  ): Promise<{ requests: StaffRequestDto[] }> {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id: restaurantId },
    });
    if (!restaurant) {
      throw notFound('RESTAURANT_NOT_FOUND', 'Restaurant not found');
    }

    const rows = await this.prisma.staff_request.findMany({
      where: { restaurant_id: restaurantId, status: 'pending' },
      orderBy: { requested_at: 'asc' },
    });
    return { requests: rows.map(mapStaffRequest) };
  }

  async handle(
    restaurantId: string,
    requestId: string,
    dto: HandleStaffRequestDto,
    actorUserId: string,
  ): Promise<StaffRequestDto> {
    const row = await this.prisma.staff_request.findFirst({
      where: { id: requestId, restaurant_id: restaurantId },
    });
    if (!row) {
      throw notFound('REQUEST_NOT_FOUND', 'Staff request not found');
    }
    if (row.status !== 'pending') {
      throw conflict('REQUEST_ALREADY_HANDLED', 'Request is not pending');
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
          id: uuidv4(),
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

    return mapStaffRequest(updated);
  }

  private async requireSession(restaurantId: string, sessionId: string) {
    const session = await this.prisma.dine_in_session.findFirst({
      where: { id: sessionId, restaurant_id: restaurantId },
    });
    if (!session) {
      throw notFound('SESSION_NOT_FOUND', 'Session not found');
    }
    return session;
  }

  private async requireOpenSession(restaurantId: string, sessionId: string) {
    const session = await this.requireSession(restaurantId, sessionId);
    if (session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is closed');
    }
    return session;
  }
}
