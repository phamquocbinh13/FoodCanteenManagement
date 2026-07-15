import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import type { JwtPayload } from '../auth/auth.types';
import {
  AppendTimelineDto,
  CloseSessionDto,
  CreateSessionDto,
  TransferSessionDto,
  UpdateSessionDto,
} from './dto/sessions.dto';
import { SessionsService } from './sessions.service';

@ApiTags('restaurant-sessions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId')
export class RestaurantSessionsController {
  constructor(private readonly sessions: SessionsService) {}

  @Post('sessions')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create dine-in session (Stage A)' })
  create(
    @Param('restaurantId') restaurantId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: CreateSessionDto,
  ) {
    return this.sessions.create(restaurantId, user.sub, dto);
  }

  @Get('sessions/active')
  @ApiOperation({ summary: 'List active sessions for restaurant' })
  listActive(@Param('restaurantId') restaurantId: string) {
    return this.sessions.listActive(restaurantId);
  }

  @Get('sessions/next-daily-sequence')
  @ApiOperation({ summary: 'Allocate next daily session sequence' })
  nextDailySequence(
    @Param('restaurantId') restaurantId: string,
    @Query('dateKey') dateKey: string,
  ) {
    return this.sessions.nextDailySequence(restaurantId, dateKey);
  }

  @Get('sessions/:sessionId')
  @ApiOperation({ summary: 'Get session by id' })
  findById(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.sessions.findById(restaurantId, sessionId);
  }

  @Get('tables/:tableId/session')
  @ApiOperation({ summary: 'Find active session for table' })
  findByTable(
    @Param('restaurantId') restaurantId: string,
    @Param('tableId') tableId: string,
  ) {
    return this.sessions.findActiveByTable(restaurantId, tableId);
  }

  @Post('sessions/:sessionId/waiting-payment')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark session waiting payment' })
  waitingPayment(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.sessions.markWaitingPayment(restaurantId, sessionId);
  }

  @Post('sessions/:sessionId/close')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Close session and free table' })
  close(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: CloseSessionDto,
  ) {
    return this.sessions.close(
      restaurantId,
      sessionId,
      dto.closedByUserId ?? user.sub,
    );
  }

  @Post('sessions/:sessionId/transfer')
  @ApiOperation({ summary: 'Transfer session (501 until Phase 2)' })
  transfer(
    @Param('restaurantId') _restaurantId: string,
    @Param('sessionId') _sessionId: string,
    @Body() _dto: TransferSessionDto,
  ) {
    return this.sessions.transfer();
  }

  @Patch('sessions/:sessionId')
  @ApiOperation({ summary: 'Update session payment summary / batch number' })
  update(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Body() dto: UpdateSessionDto,
  ) {
    return this.sessions.update(restaurantId, sessionId, dto);
  }

  @Post('sessions/:sessionId/timeline')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Append session timeline event' })
  appendTimeline(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: AppendTimelineDto,
  ) {
    return this.sessions.appendTimeline(
      restaurantId,
      sessionId,
      dto,
      user.sub,
    );
  }

  @Post('sessions/:sessionId/next-batch-number')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Increment and return next batch number' })
  nextBatchNumber(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.sessions.nextBatchNumber(restaurantId, sessionId);
  }

  @Get('sessions/:sessionId/bill')
  @ApiOperation({ summary: 'Get session payment summary (bill)' })
  bill(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.sessions.getBill(restaurantId, sessionId);
  }
}
