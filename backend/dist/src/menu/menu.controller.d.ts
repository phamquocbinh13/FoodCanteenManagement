import type { JwtPayload } from '../auth/auth.types';
import { ToggleAvailabilityDto } from './dto/menu.dto';
import { MenuService } from './menu.service';
export declare class MenuController {
    private readonly menu;
    constructor(menu: MenuService);
    getCatalog(restaurantId: string): Promise<{
        menuVersion: number;
        categories: import("./menu.mapper").MenuCategoryDto[];
        items: import("./menu.mapper").MenuItemDto[];
    }>;
    getItem(restaurantId: string, itemId: string): Promise<{
        item: import("./menu.mapper").MenuItemDto;
        groups: import("../common/menu/customization-pricing").CatalogGroup[];
    }>;
    kitchenMenu(restaurantId: string): Promise<{
        items: import("./menu.mapper").MenuItemDto[];
    }>;
    toggle(restaurantId: string, itemId: string, user: JwtPayload, dto: ToggleAvailabilityDto): Promise<import("./menu.mapper").MenuItemDto>;
}
