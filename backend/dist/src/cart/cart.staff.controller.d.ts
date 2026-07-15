import { CartService } from './cart.service';
import { AddCartItemDto, PatchCartItemDto, PutCartItemSelectionsDto } from './dto/cart.dto';
export declare class CartStaffController {
    private readonly cart;
    constructor(cart: CartService);
    get(restaurantId: string, sessionId: string): Promise<import("./cart.mapper").CartResponse>;
    add(restaurantId: string, sessionId: string, dto: AddCartItemDto): Promise<import("./cart.mapper").CartResponse>;
    patch(restaurantId: string, sessionId: string, id: string, dto: PatchCartItemDto): Promise<import("./cart.mapper").CartResponse>;
    putSelections(restaurantId: string, sessionId: string, id: string, dto: PutCartItemSelectionsDto): Promise<import("./cart.mapper").CartResponse>;
    remove(restaurantId: string, sessionId: string, id: string): Promise<import("./cart.mapper").CartResponse>;
    clear(restaurantId: string, sessionId: string): Promise<import("./cart.mapper").CartResponse>;
}
