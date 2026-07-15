import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import {
  forbidden,
  notFound,
  unprocessable,
} from '../common/errors/api-exception';
import {
  mapGroup,
  type CatalogGroup,
} from '../common/menu/customization-pricing';
import { PrismaService } from '../prisma/prisma.service';
import {
    mapCategory,
  mapMenuItem,
  menuVersionFromDates,
  type MenuCategoryDto,
  type MenuItemDto,
} from './menu.mapper';

@Injectable()
export class MenuService {
  constructor(private readonly prisma: PrismaService) {}

  async getCatalog(restaurantId: string): Promise<{
    menuVersion: number;
    categories: MenuCategoryDto[];
    items: MenuItemDto[];
  }> {
    await this.requireRestaurant(restaurantId);

    const [categories, items] = await Promise.all([
      this.prisma.menuCategory.findMany({
        where: { restaurantId, isActive: true },
        orderBy: { sortOrder: 'asc' },
      }),
      this.prisma.menuItem.findMany({
        where: {
          restaurantId,
          isActive: true,
          availability: 'available',
        },
        orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
      }),
    ]);

    const allForVersion = await this.prisma.menuItem.findMany({
      where: { restaurantId },
      select: { updatedAt: true },
    });

    return {
      menuVersion: menuVersionFromDates(allForVersion.map((r) => r.updatedAt)),
      categories: categories.map(mapCategory),
      items: items.map(mapMenuItem),
    };
  }

  async getItemDetail(
    restaurantId: string,
    itemId: string,
  ): Promise<{
    item: MenuItemDto;
    groups: CatalogGroup[];
  }> {
    const item = await this.prisma.menuItem.findFirst({
      where: { id: itemId, restaurantId },
    });
    if (!item) {
      throw notFound('MENU_ITEM_NOT_FOUND', 'Menu item not found');
    }

    const groups = await this.prisma.customization_group.findMany({
      where: { menu_item_id: itemId, is_active: true },
      include: {
        customization_option: {
          where: { is_active: true },
          orderBy: { sort_order: 'asc' },
        },
      },
      orderBy: { sort_order: 'asc' },
    });

    return {
      item: mapMenuItem(item),
      groups: groups.map(mapGroup),
    };
  }

  async getKitchenMenu(restaurantId: string): Promise<{
    items: MenuItemDto[];
  }> {
    await this.requireRestaurant(restaurantId);
    const items = await this.prisma.menuItem.findMany({
      where: { restaurantId, isActive: true },
      orderBy: [{ sortOrder: 'asc' }, { name: 'asc' }],
    });
    return { items: items.map(mapMenuItem) };
  }

  async toggleAvailability(
    restaurantId: string,
    itemId: string,
    changedByUserId: string,
  ): Promise<MenuItemDto> {
    const item = await this.prisma.menuItem.findFirst({
      where: { id: itemId, restaurantId },
    });
    if (!item) {
      throw notFound('MENU_ITEM_NOT_FOUND', 'Menu item not found');
    }
    if (!item.isActive) {
      throw unprocessable('MENU_ITEM_INACTIVE', 'Menu item is inactive');
    }

    const from = item.availability;
    const to = from === 'available' ? 'out_of_stock' : 'available';
    const now = new Date();

    const staff = await this.prisma.staffUser.findFirst({
      where: { id: changedByUserId, restaurantId },
    });
    if (!staff) {
      throw forbidden('STAFF_NOT_FOUND', 'Staff user not found for restaurant');
    }

    const updated = await this.prisma.$transaction(async (tx) => {
      const row = await tx.menuItem.update({
        where: { id: itemId },
        data: { availability: to, updatedAt: now },
      });
      await tx.menu_item_availability_history.create({
        data: {
          id: uuidv4(),
          menu_item_id: itemId,
          from_availability: from,
          to_availability: to,
          changed_by_user_id: changedByUserId,
          occurred_at: now,
        },
      });
      return row;
    });

    return mapMenuItem(updated);
  }

  private async requireRestaurant(restaurantId: string): Promise<void> {
    const r = await this.prisma.restaurant.findUnique({
      where: { id: restaurantId },
    });
    if (!r) {
      throw notFound('RESTAURANT_NOT_FOUND', 'Restaurant not found');
    }
  }
}
