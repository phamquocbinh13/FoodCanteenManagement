import { session_cart_item } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { type CartResponse, type SessionCartItemDto } from './cart.mapper';
import { AddCartItemDto, PatchCartItemDto, PutCartItemSelectionsDto } from './dto/cart.dto';
export declare class CartService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    getCart(restaurantId: string, sessionId: string): Promise<CartResponse>;
    addItem(restaurantId: string, sessionId: string, dto: AddCartItemDto): Promise<CartResponse>;
    patchItem(restaurantId: string, sessionId: string, itemId: string, dto: PatchCartItemDto): Promise<CartResponse>;
    putSelections(restaurantId: string, sessionId: string, itemId: string, dto: PutCartItemSelectionsDto): Promise<CartResponse>;
    removeItem(restaurantId: string, sessionId: string, itemId: string): Promise<CartResponse>;
    clearCart(restaurantId: string, sessionId: string): Promise<CartResponse>;
    listItemsInternal(sessionId: string): Promise<{
        cartId: string;
        cartVersion: number;
        items: SessionCartItemDto[];
        rawItems: session_cart_item[];
    }>;
    private loadGroups;
    private requireOpenSession;
    private getOrCreateCart;
    private getOrCreateCartTx;
}
