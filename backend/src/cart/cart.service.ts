import { Injectable } from '@nestjs/common';
import { Prisma, session_cart_item } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';
import {
  notFound,
  unprocessable,
} from '../common/errors/api-exception';
import { validateAndPrice } from '../common/menu/customization-pricing';
import { PrismaService } from '../prisma/prisma.service';
import {
  asJsonObject,
  mapCart,
  mapCartItem,
  toInputJson,
  type CartResponse,
  type SessionCartItemDto,
} from './cart.mapper';
import {
  AddCartItemDto,
  PatchCartItemDto,
  PutCartItemSelectionsDto,
} from './dto/cart.dto';

@Injectable()
export class CartService {
  constructor(private readonly prisma: PrismaService) {}

  async getCart(
    restaurantId: string,
    sessionId: string,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    const cart = await this.getOrCreateCart(sessionId);
    const items = await this.prisma.session_cart_item.findMany({
      where: { session_cart_id: cart.id },
      orderBy: { created_at: 'asc' },
    });
    return { cart: mapCart(cart), items: items.map(mapCartItem) };
  }

  async addItem(
    restaurantId: string,
    sessionId: string,
    dto: AddCartItemDto,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    const menuItem = await this.prisma.menuItem.findFirst({
      where: { id: dto.menuItemId, restaurantId },
    });
    if (!menuItem || !menuItem.isActive) {
      throw notFound('MENU_ITEM_NOT_FOUND', 'Menu item not found');
    }
    if (menuItem.availability !== 'available') {
      throw unprocessable('MENU_ITEM_UNAVAILABLE', 'Menu item is unavailable');
    }

    const groups = await this.loadGroups(dto.menuItemId);
    const selectionsJson = asJsonObject(dto.selectionsJson ?? {});
    let priced;
    try {
      priced = validateAndPrice({
        basePriceMinor: menuItem.basePriceMinor,
        currencyCode: menuItem.currencyCode,
        groups,
        selectionsJson,
      });
    } catch (e) {
      const err = e as Error & { code?: string };
      throw unprocessable(err.code ?? 'INVALID_SELECTIONS', err.message);
    }

    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      const cart = await this.getOrCreateCartTx(tx, sessionId, now);
      await tx.session_cart_item.create({
        data: {
          id: uuidv4(),
          session_cart_id: cart.id,
          menu_item_id: menuItem.id,
          quantity: dto.quantity,
          selections_json: toInputJson(selectionsJson),
          unit_price_minor: priced.unitPriceMinor,
          currency_code: priced.currencyCode,
          created_at: now,
          updated_at: now,
        },
      });
      await tx.session_cart.update({
        where: { id: cart.id },
        data: { version: cart.version + 1, updated_at: now },
      });
      await tx.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'cart_item_added',
          payload_json: {
            menuItemId: menuItem.id,
            quantity: dto.quantity,
          },
          actor_type: 'customer_session',
          actor_id: null,
          occurred_at: now,
        },
      });
    });

    return this.getCart(restaurantId, sessionId);
  }

  async patchItem(
    restaurantId: string,
    sessionId: string,
    itemId: string,
    dto: PatchCartItemDto,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    if (dto.quantity == null && dto.delta == null) {
      throw unprocessable('INVALID_PATCH', 'Provide quantity or delta');
    }

    const cart = await this.getOrCreateCart(sessionId);
    const item = await this.prisma.session_cart_item.findFirst({
      where: { id: itemId, session_cart_id: cart.id },
    });
    if (!item) {
      throw notFound('CART_ITEM_NOT_FOUND', 'Cart item not found');
    }

    let nextQty = item.quantity;
    if (dto.quantity != null) nextQty = dto.quantity;
    else if (dto.delta != null) nextQty = item.quantity + dto.delta;

    if (nextQty < 1) {
      throw unprocessable('INVALID_QUANTITY', 'Quantity must be at least 1');
    }

    const now = new Date();
    await this.prisma.$transaction([
      this.prisma.session_cart_item.update({
        where: { id: itemId },
        data: { quantity: nextQty, updated_at: now },
      }),
      this.prisma.session_cart.update({
        where: { id: cart.id },
        data: { version: cart.version + 1, updated_at: now },
      }),
    ]);

    return this.getCart(restaurantId, sessionId);
  }

  async putSelections(
    restaurantId: string,
    sessionId: string,
    itemId: string,
    dto: PutCartItemSelectionsDto,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    const cart = await this.getOrCreateCart(sessionId);
    const item = await this.prisma.session_cart_item.findFirst({
      where: { id: itemId, session_cart_id: cart.id },
    });
    if (!item) {
      throw notFound('CART_ITEM_NOT_FOUND', 'Cart item not found');
    }

    const menuItem = await this.prisma.menuItem.findUnique({
      where: { id: item.menu_item_id },
    });
    if (!menuItem) {
      throw notFound('MENU_ITEM_NOT_FOUND', 'Menu item not found');
    }

    const groups = await this.loadGroups(menuItem.id);
    const selectionsJson = asJsonObject(dto.selectionsJson);
    let priced;
    try {
      priced = validateAndPrice({
        basePriceMinor: menuItem.basePriceMinor,
        currencyCode: menuItem.currencyCode,
        groups,
        selectionsJson,
      });
    } catch (e) {
      const err = e as Error & { code?: string };
      throw unprocessable(err.code ?? 'INVALID_SELECTIONS', err.message);
    }

    const now = new Date();
    await this.prisma.$transaction([
      this.prisma.session_cart_item.update({
        where: { id: itemId },
        data: {
          selections_json: toInputJson(selectionsJson),
          unit_price_minor: priced.unitPriceMinor,
          currency_code: priced.currencyCode,
          updated_at: now,
        },
      }),
      this.prisma.session_cart.update({
        where: { id: cart.id },
        data: { version: cart.version + 1, updated_at: now },
      }),
    ]);

    return this.getCart(restaurantId, sessionId);
  }

  async removeItem(
    restaurantId: string,
    sessionId: string,
    itemId: string,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    const cart = await this.getOrCreateCart(sessionId);
    const item = await this.prisma.session_cart_item.findFirst({
      where: { id: itemId, session_cart_id: cart.id },
    });
    if (!item) {
      throw notFound('CART_ITEM_NOT_FOUND', 'Cart item not found');
    }

    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      await tx.session_cart_item.delete({ where: { id: itemId } });
      await tx.session_cart.update({
        where: { id: cart.id },
        data: { version: cart.version + 1, updated_at: now },
      });
      await tx.session_timeline_event.create({
        data: {
          id: uuidv4(),
          session_id: sessionId,
          event_type: 'cart_item_removed',
          payload_json: { cartItemId: itemId },
          actor_type: 'customer_session',
          actor_id: null,
          occurred_at: now,
        },
      });
    });

    return this.getCart(restaurantId, sessionId);
  }

  async clearCart(
    restaurantId: string,
    sessionId: string,
  ): Promise<CartResponse> {
    await this.requireOpenSession(restaurantId, sessionId);
    const cart = await this.getOrCreateCart(sessionId);
    const now = new Date();
    await this.prisma.$transaction([
      this.prisma.session_cart_item.deleteMany({
        where: { session_cart_id: cart.id },
      }),
      this.prisma.session_cart.update({
        where: { id: cart.id },
        data: { version: cart.version + 1, updated_at: now },
      }),
    ]);
    return this.getCart(restaurantId, sessionId);
  }

  /** Used by batches confirm — returns mapped items without wrapping. */
  async listItemsInternal(sessionId: string): Promise<{
    cartId: string;
    cartVersion: number;
    items: SessionCartItemDto[];
    rawItems: session_cart_item[];
  }> {
    const cart = await this.getOrCreateCart(sessionId);
    const rawItems = await this.prisma.session_cart_item.findMany({
      where: { session_cart_id: cart.id },
      orderBy: { created_at: 'asc' },
    });
    return {
      cartId: cart.id,
      cartVersion: cart.version,
      items: rawItems.map(mapCartItem),
      rawItems,
    };
  }

  private async loadGroups(menuItemId: string) {
    return this.prisma.customization_group.findMany({
      where: { menu_item_id: menuItemId, is_active: true },
      include: {
        customization_option: {
          where: { is_active: true },
          orderBy: { sort_order: 'asc' },
        },
      },
      orderBy: { sort_order: 'asc' },
    });
  }

  private async requireOpenSession(
    restaurantId: string,
    sessionId: string,
  ) {
    const session = await this.prisma.dine_in_session.findFirst({
      where: { id: sessionId, restaurant_id: restaurantId },
    });
    if (!session) {
      throw notFound('SESSION_NOT_FOUND', 'Session not found');
    }
    if (session.status === 'closed') {
      throw unprocessable('SESSION_CLOSED', 'Session is closed');
    }
    return session;
  }

  private async getOrCreateCart(sessionId: string) {
    const existing = await this.prisma.session_cart.findUnique({
      where: { session_id: sessionId },
    });
    if (existing) return existing;
    const now = new Date();
    return this.prisma.session_cart.create({
      data: {
        id: uuidv4(),
        session_id: sessionId,
        version: 1,
        created_at: now,
        updated_at: now,
      },
    });
  }

  private async getOrCreateCartTx(
    tx: Prisma.TransactionClient,
    sessionId: string,
    now: Date,
  ) {
    const existing = await tx.session_cart.findUnique({
      where: { session_id: sessionId },
    });
    if (existing) return existing;
    return tx.session_cart.create({
      data: {
        id: uuidv4(),
        session_id: sessionId,
        version: 1,
        created_at: now,
        updated_at: now,
      },
    });
  }
}
