import { type CustomerSessionContext } from '../sessions/guards/session-token.guard';
import { CartService } from './cart.service';
import { AddCartItemDto, PatchCartItemDto, PutCartItemSelectionsDto } from './dto/cart.dto';
export declare class CartCustomerController {
    private readonly cart;
    constructor(cart: CartService);
    get(ctx: CustomerSessionContext): Promise<import("./cart.mapper").CartResponse>;
    add(ctx: CustomerSessionContext, dto: AddCartItemDto): Promise<import("./cart.mapper").CartResponse>;
    patch(ctx: CustomerSessionContext, id: string, dto: PatchCartItemDto): Promise<import("./cart.mapper").CartResponse>;
    putSelections(ctx: CustomerSessionContext, id: string, dto: PutCartItemSelectionsDto): Promise<import("./cart.mapper").CartResponse>;
    remove(ctx: CustomerSessionContext, id: string): Promise<import("./cart.mapper").CartResponse>;
    clear(ctx: CustomerSessionContext): Promise<import("./cart.mapper").CartResponse>;
}
