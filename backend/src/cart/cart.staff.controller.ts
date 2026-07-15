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
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RestaurantScopeGuard } from '../auth/guards/restaurant-scope.guard';
import { CartService } from './cart.service';
import {
  AddCartItemDto,
  PatchCartItemDto,
  PutCartItemSelectionsDto,
} from './dto/cart.dto';

@ApiTags('cart-staff')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RestaurantScopeGuard)
@Controller('restaurants/:restaurantId/sessions/:sessionId/cart')
export class CartStaffController {
  constructor(private readonly cart: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Staff: get session cart' })
  get(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.cart.getCart(restaurantId, sessionId);
  }

  @Post('items')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Staff: add cart item' })
  add(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Body() dto: AddCartItemDto,
  ) {
    return this.cart.addItem(restaurantId, sessionId, dto);
  }

  @Patch('items/:id')
  @ApiOperation({ summary: 'Staff: patch cart item quantity' })
  patch(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Param('id') id: string,
    @Body() dto: PatchCartItemDto,
  ) {
    return this.cart.patchItem(restaurantId, sessionId, id, dto);
  }

  @Put('items/:id')
  @ApiOperation({ summary: 'Staff: replace cart item selections' })
  putSelections(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Param('id') id: string,
    @Body() dto: PutCartItemSelectionsDto,
  ) {
    return this.cart.putSelections(restaurantId, sessionId, id, dto);
  }

  @Delete('items/:id')
  @ApiOperation({ summary: 'Staff: remove cart item' })
  remove(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
    @Param('id') id: string,
  ) {
    return this.cart.removeItem(restaurantId, sessionId, id);
  }

  @Delete()
  @ApiOperation({ summary: 'Staff: clear cart' })
  clear(
    @Param('restaurantId') restaurantId: string,
    @Param('sessionId') sessionId: string,
  ) {
    return this.cart.clearCart(restaurantId, sessionId);
  }
}
