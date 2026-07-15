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
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentSession } from '../sessions/decorators/current-session.decorator';
import {
  SessionTokenGuard,
  type CustomerSessionContext,
} from '../sessions/guards/session-token.guard';
import { CartService } from './cart.service';
import {
  AddCartItemDto,
  PatchCartItemDto,
  PutCartItemSelectionsDto,
} from './dto/cart.dto';

@ApiTags('cart')
@ApiHeader({ name: 'X-Session-Token', required: false })
@UseGuards(SessionTokenGuard)
@Controller('sessions/me/cart')
export class CartCustomerController {
  constructor(private readonly cart: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get current session cart' })
  get(@CurrentSession() ctx: CustomerSessionContext) {
    return this.cart.getCart(ctx.restaurantId, ctx.sessionId);
  }

  @Post('items')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Add item to cart' })
  add(
    @CurrentSession() ctx: CustomerSessionContext,
    @Body() dto: AddCartItemDto,
  ) {
    return this.cart.addItem(ctx.restaurantId, ctx.sessionId, dto);
  }

  @Patch('items/:id')
  @ApiOperation({ summary: 'Update cart item quantity' })
  patch(
    @CurrentSession() ctx: CustomerSessionContext,
    @Param('id') id: string,
    @Body() dto: PatchCartItemDto,
  ) {
    return this.cart.patchItem(ctx.restaurantId, ctx.sessionId, id, dto);
  }

  @Put('items/:id')
  @ApiOperation({ summary: 'Replace cart item selections' })
  putSelections(
    @CurrentSession() ctx: CustomerSessionContext,
    @Param('id') id: string,
    @Body() dto: PutCartItemSelectionsDto,
  ) {
    return this.cart.putSelections(ctx.restaurantId, ctx.sessionId, id, dto);
  }

  @Delete('items/:id')
  @ApiOperation({ summary: 'Remove cart item' })
  remove(
    @CurrentSession() ctx: CustomerSessionContext,
    @Param('id') id: string,
  ) {
    return this.cart.removeItem(ctx.restaurantId, ctx.sessionId, id);
  }

  @Delete()
  @ApiOperation({ summary: 'Clear cart' })
  clear(@CurrentSession() ctx: CustomerSessionContext) {
    return this.cart.clearCart(ctx.restaurantId, ctx.sessionId);
  }
}
