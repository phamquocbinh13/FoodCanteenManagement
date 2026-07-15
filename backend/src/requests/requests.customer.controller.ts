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
import { CreateStaffRequestDto } from './dto/requests.dto';
import { RequestsService } from './requests.service';

@ApiTags('requests')
@ApiHeader({ name: 'X-Session-Token', required: false })
@UseGuards(SessionTokenGuard)
@Controller('sessions/me/requests')
export class RequestsCustomerController {
  constructor(private readonly requests: RequestsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create staff request' })
  create(
    @CurrentSession() ctx: CustomerSessionContext,
    @Body() dto: CreateStaffRequestDto,
  ) {
    return this.requests.create(ctx.restaurantId, ctx.sessionId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'List requests for current session' })
  list(@CurrentSession() ctx: CustomerSessionContext) {
    return this.requests.listForSession(ctx.restaurantId, ctx.sessionId);
  }
}
