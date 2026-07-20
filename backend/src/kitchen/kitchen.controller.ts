import {
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
import { KitchenService } from './kitchen.service';

@ApiTags('kitchen')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId/kitchen')
export class KitchenController {
  constructor(private readonly kitchen: KitchenService) {}

  @Get('queue')
  @ApiOperation({
    summary: 'Kitchen queue — batches with items/tableLabel, no payment',
  })
  queue(@Param('restaurantId') restaurantId: string) {
    return this.kitchen.getQueue(restaurantId);
  }

  @Get('overview')
  @ApiOperation({
    summary: 'Kitchen overview aggregate — active orders, wait times, demand',
  })
  overview(@Param('restaurantId') restaurantId: string) {
    return this.kitchen.getOverview(restaurantId);
  }

  @Get('workflow')
  @ApiOperation({
    summary: 'Kitchen workflow aggregate — production priority buckets, customizations, and stats',
  })
  workflow(@Param('restaurantId') restaurantId: string) {
    return this.kitchen.getWorkflow(restaurantId);
  }

  @Post('items/:batchItemId/complete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark batch item completed' })
  complete(
    @Param('restaurantId') restaurantId: string,
    @Param('batchItemId') batchItemId: string,
    @CurrentUser() user: JwtPayload,
  ) {
    return this.kitchen.completeBatchItem(
      restaurantId,
      batchItemId,
      user.sub,
    );
  }
}
