import { type CatalogGroup } from '../common/menu/customization-pricing';
import { PrismaService } from '../prisma/prisma.service';
import { type MenuCategoryDto, type MenuItemDto } from './menu.mapper';
export declare class MenuService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    getCatalog(restaurantId: string): Promise<{
        menuVersion: number;
        categories: MenuCategoryDto[];
        items: MenuItemDto[];
    }>;
    getItemDetail(restaurantId: string, itemId: string): Promise<{
        item: MenuItemDto;
        groups: CatalogGroup[];
    }>;
    getKitchenMenu(restaurantId: string): Promise<{
        items: MenuItemDto[];
    }>;
    toggleAvailability(restaurantId: string, itemId: string, changedByUserId: string): Promise<MenuItemDto>;
    private requireRestaurant;
}
