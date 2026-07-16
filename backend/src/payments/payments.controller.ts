import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import type { JwtPayload } from '../auth/auth.types';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { CreateSessionPaymentDto } from './dto/create-session-payment.dto';
import { PaymentsService } from './payments.service';

@ApiTags('payments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId/sessions/:sessionId/payments')
export class PaymentsController {
  constructor(private readonly payments: PaymentsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Atomic session payment close (bill + close + revoke tokens)',
  })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description:
      'Optional. Idempotency is enforced via UNIQUE(session_id) on session_payment.',
  })
  create(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: CreateSessionPaymentDto,
    @Headers('idempotency-key') _idempotencyKey?: string,
  ) {
    return this.payments.create(restaurantId, sessionId, user.sub, dto);
  }

  @Get('balance')
  @ApiOperation({
    summary: 'Get session outstanding balance',
  })
  balance(@Param('sessionId') sessionId: string) {
    return this.payments.calculateSessionBalance(sessionId);
  }
}
