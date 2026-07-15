import { Prisma, session_cart, session_cart_item } from '@prisma/client';
import { type MoneyDto } from '../common/menu/customization-pricing';
export type SessionCartDto = {
    id: string;
    sessionId: string;
    version: number;
    updatedAt: string;
    createdAt: string;
};
export type SessionCartItemDto = {
    id: string;
    sessionCartId: string;
    menuItemId: string;
    quantity: number;
    selectionsJson: Record<string, unknown>;
    unitPriceSnapshot: MoneyDto;
    createdAt: string;
    updatedAt: string;
};
export type CartResponse = {
    cart: SessionCartDto;
    items: SessionCartItemDto[];
};
export declare function mapCart(row: session_cart): SessionCartDto;
export declare function mapCartItem(row: session_cart_item): SessionCartItemDto;
export declare function asJsonObject(value: unknown): Record<string, unknown>;
export declare function toInputJson(value: Record<string, unknown>): Prisma.InputJsonValue;
