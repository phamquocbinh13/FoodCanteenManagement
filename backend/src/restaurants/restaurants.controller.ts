import { Controller, Get, NotFoundException, Param } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('restaurants')
@Controller('restaurants')
export class RestaurantsController {
  constructor(private readonly prisma: PrismaService) {}

  @Get(':restaurantId')
  @ApiOperation({ summary: 'Get restaurant by id (B0 smoke endpoint)' })
  async findById(@Param('restaurantId') restaurantId: string) {
    const restaurant = await this.prisma.restaurant.findUnique({
      where: { id: restaurantId },
      include: { settings: true },
    });
    if (!restaurant) {
      throw new NotFoundException({
        error: {
          code: 'RESTAURANT_NOT_FOUND',
          message: 'Restaurant not found',
        },
      });
    }
    return restaurant;
  }

  @Get(':restaurantId/tables')
  @ApiOperation({ summary: 'List tables for restaurant (B0 smoke endpoint)' })
  async listTables(@Param('restaurantId') restaurantId: string) {
    const items = await this.prisma.restaurantTable.findMany({
      where: { restaurantId, isActive: true },
      orderBy: { sortOrder: 'asc' },
    });
    return { items };
  }
}
