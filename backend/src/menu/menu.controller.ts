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
import { ToggleAvailabilityDto } from './dto/menu.dto';
import { MenuService } from './menu.service';

@ApiTags('menu')
@Controller('restaurants/:restaurantId')
export class MenuController {
  constructor(private readonly menu: MenuService) {}

  @Get('menu')
  @ApiOperation({ summary: 'Customer menu catalog' })
  getCatalog(@Param('restaurantId') restaurantId: string) {
    return this.menu.getCatalog(restaurantId);
  }

  @Get('menu/items/:itemId')
  @ApiOperation({ summary: 'Menu item detail with customization groups' })
  getItem(
    @Param('restaurantId') restaurantId: string,
    @Param('itemId') itemId: string,
  ) {
    return this.menu.getItemDetail(restaurantId, itemId);
  }

  @Get('kitchen/menu')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RestaurantScopeGuard)
  @ApiOperation({ summary: 'Kitchen menu panel — all active items' })
  kitchenMenu(@Param('restaurantId') restaurantId: string) {
    return this.menu.getKitchenMenu(restaurantId);
  }

  @Post('menu/items/:itemId/toggle-availability')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard, RestaurantScopeGuard)
  @ApiOperation({ summary: 'Toggle available ↔ out_of_stock' })
  toggle(
    @Param('restaurantId') restaurantId: string,
    @Param('itemId') itemId: string,
    @CurrentUser() user: JwtPayload,
    @Body() dto: ToggleAvailabilityDto,
  ) {
    return this.menu.toggleAvailability(
      restaurantId,
      itemId,
      dto.changedByUserId ?? user.sub,
    );
  }
}
