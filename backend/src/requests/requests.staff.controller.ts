import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import type { JwtPayload } from '../auth/auth.types';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { HandleStaffRequestDto } from './dto/requests.dto';
import { RequestsService } from './requests.service';

@ApiTags('requests-staff')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId')
export class RequestsStaffController {
  constructor(private readonly requests: RequestsService) {}

  @Get('requests/pending')
  @ApiOperation({ summary: 'Pending staff requests queue' })
  pending(@Param('restaurantId') restaurantId: string) {
    return this.requests.listPending(restaurantId);
  }

  @Get('sessions/:sessionId/requests')
  @ApiOperation({ summary: 'List requests for a session' })
  listSession(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.requests.listForSession(restaurantId, sessionId);
  }

  @Post('requests/:requestId/handle')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark staff request handled' })
  handle(
    @Param('restaurantId') restaurantId: string,
    @Param('requestId') requestId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: HandleStaffRequestDto,
  ) {
    return this.requests.handle(restaurantId, requestId, dto, user.sub);
  }
}
