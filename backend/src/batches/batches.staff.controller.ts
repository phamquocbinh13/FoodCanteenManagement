import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { BatchesService } from './batches.service';
import {
  BulkCustomizationsDto,
  ConfirmBatchDto,
  CreateBatchDto,
  CreateBatchItemDto,
  UpdateBatchItemQuantityDto,
} from './dto/batches.dto';

@ApiTags('batches-staff')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId')
export class BatchesStaffController {
  constructor(private readonly batches: BatchesService) {}

  @Post('sessions/:sessionId/batches/confirm')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Staff: confirm session cart to batch' })
  confirm(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Body() dto: ConfirmBatchDto,
  ) {
    return this.batches.confirmFromCart(restaurantId, sessionId, {
      ...dto,
      actorType: dto.actorType ?? 'user',
    });
  }

  @Get('sessions/:sessionId/batches')
  @ApiOperation({ summary: 'List batches for session' })
  listSession(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.batches.listSessionBatches(restaurantId, sessionId);
  }

  @Post('sessions/:sessionId/batches')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create KitchenBatch entity' })
  createBatch(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Body() dto: CreateBatchDto,
  ) {
    return this.batches.createBatch(restaurantId, sessionId, dto);
  }

  @Post('batches/:batchId/items')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create batch item' })
  createItem(
    @Param('restaurantId') restaurantId: string,
    @Param('batchId') batchId: string,
    @Body() dto: CreateBatchItemDto,
  ) {
    return this.batches.createBatchItem(restaurantId, batchId, dto);
  }

  @Post('batch-items/:batchItemId/customizations')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Bulk create batch item customizations' })
  createCustomizations(
    @Param('restaurantId') restaurantId: string,
    @Param('batchItemId') batchItemId: string,
    @Body() dto: BulkCustomizationsDto,
  ) {
    return this.batches.createCustomizations(
      restaurantId,
      batchItemId,
      dto,
    );
  }

  @Get('batches/:batchId')
  @ApiOperation({ summary: 'Get batch ticket by id' })
  getBatch(
    @Param('restaurantId') restaurantId: string,
    @Param('batchId') batchId: string,
  ) {
    return this.batches.getBatch(restaurantId, batchId);
  }

  @Patch('batch-items/:batchItemId/quantity')
  @ApiOperation({ summary: 'Update batch item quantity' })
  updateItemQuantity(
    @Param('restaurantId') restaurantId: string,
    @Param('batchItemId') batchItemId: string,
    @Body() dto: UpdateBatchItemQuantityDto,
  ) {
    return this.batches.updateItemQuantity(
      restaurantId,
      batchItemId,
      dto.delta,
    );
  }

  @Delete('batch-items/:batchItemId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete batch item' })
  deleteItem(
    @Param('restaurantId') restaurantId: string,
    @Param('batchItemId') batchItemId: string,
  ) {
    return this.batches.deleteItem(restaurantId, batchItemId);
  }
}
