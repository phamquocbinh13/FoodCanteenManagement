import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentSession } from '../sessions/decorators/current-session.decorator';
import {
  SessionTokenGuard,
  type CustomerSessionContext,
} from '../sessions/guards/session-token.guard';
import { BatchesService } from './batches.service';
import { ConfirmBatchDto } from './dto/batches.dto';

@ApiTags('batches')
@ApiHeader({ name: 'X-Session-Token', required: false })
@UseGuards(SessionTokenGuard)
@Controller('sessions/me/batches')
export class BatchesCustomerController {
  constructor(private readonly batches: BatchesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Confirm cart → kitchen batch ticket' })
  confirm(
    @CurrentSession() ctx: CustomerSessionContext,
    @Body() dto: ConfirmBatchDto,
  ) {
    return this.batches.confirmFromCart(
      ctx.restaurantId,
      ctx.sessionId,
      dto,
    );
  }

  @Get('progress')
  @ApiOperation({ summary: 'Customer batch progress (no item detail)' })
  progress(@CurrentSession() ctx: CustomerSessionContext) {
    return this.batches.getProgress(ctx.restaurantId, ctx.sessionId);
  }
}
