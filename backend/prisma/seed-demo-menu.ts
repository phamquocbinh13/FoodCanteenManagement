/**
 * Aligns MySQL menu catalog with Flutter DemoMenuSeed.
 *
 * Usage: npm run seed:demo-menu
 */
import { config as loadEnv } from 'dotenv';
import { resolve } from 'path';
import { PrismaClient } from '@prisma/client';

loadEnv({ path: resolve(__dirname, '../.env') });

const RID = 'demo-restaurant';
const CURRENCY = 'VND';

type RicePrefix = 'curry' | 'pork' | 'mushroom' | 'braised' | 'fried';

const CATEGORIES = [
  { id: 'cat-rice', name: '🍛 Rice', sortOrder: 1 },
  { id: 'cat-drinks', name: '🥤 Drinks', sortOrder: 2 },
] as const;

const RICE_ITEMS: Array<{
  id: string;
  name: string;
  description: string;
  priceMinor: bigint;
  sortOrder: number;
  prefix: RicePrefix;
}> = [
  {
    id: 'item-curry-rice',
    name: 'Cơm cà ri gà',
    description: 'Chicken Curry Rice',
    priceMinor: 4500000n,
    sortOrder: 1,
    prefix: 'curry',
  },
  {
    id: 'item-pork-roll-rice',
    name: 'Cơm chả lá lốt',
    description: 'Grilled Pork Roll Rice',
    priceMinor: 4200000n,
    sortOrder: 2,
    prefix: 'pork',
  },
  {
    id: 'item-mushroom-rice',
    name: 'Cơm gà xào nấm',
    description: 'Chicken Mushroom Rice',
    priceMinor: 4700000n,
    sortOrder: 3,
    prefix: 'mushroom',
  },
  {
    id: 'item-braised-pork-rice',
    name: 'Cơm trứng thịt kho tàu',
    description: 'Braised Pork Egg Rice',
    priceMinor: 4300000n,
    sortOrder: 4,
    prefix: 'braised',
  },
  {
    id: 'item-fried-chicken-rice',
    name: 'Cơm gà chiên giòn',
    description: 'Crispy Fried Chicken Rice',
    priceMinor: 4900000n,
    sortOrder: 5,
    prefix: 'fried',
  },
];

const DRINK_ITEMS: Array<{
  id: string;
  name: string;
  priceMinor: bigint;
  sortOrder: number;
}> = [
  { id: 'item-tra-da', name: 'Trà đá', priceMinor: 500000n, sortOrder: 1 },
  { id: 'item-coca', name: 'Coca Cola', priceMinor: 1500000n, sortOrder: 2 },
  { id: 'item-pepsi', name: 'Pepsi', priceMinor: 1500000n, sortOrder: 3 },
  { id: 'item-sprite', name: 'Sprite', priceMinor: 1500000n, sortOrder: 4 },
];

const DEMO_ITEM_IDS = [
  ...RICE_ITEMS.map((i) => i.id),
  ...DRINK_ITEMS.map((i) => i.id),
];

function riceGroups(itemId: string, prefix: RicePrefix) {
  return {
    groups: [
      {
        id: `grp-${prefix}-size`,
        menuItemId: itemId,
        key: 'rice_size',
        name: 'Cỡ cơm',
        selectionType: 'single_select',
        isRequired: true,
        minSelections: 1,
        maxSelections: 1,
        sortOrder: 1,
        options: [
          {
            id: `opt-${prefix}-less`,
            key: 'less',
            name: 'Ít cơm',
            kitchenLabel: 'Ít cơm',
            priceDeltaMinor: 0n,
            isDefault: false,
            sortOrder: 1,
          },
          {
            id: `opt-${prefix}-normal`,
            key: 'normal',
            name: 'Bình thường',
            kitchenLabel: 'Cơm bình thường',
            priceDeltaMinor: 0n,
            isDefault: true,
            sortOrder: 2,
          },
          {
            id: `opt-${prefix}-more`,
            key: 'more',
            name: 'Nhiều cơm',
            kitchenLabel: 'Nhiều cơm',
            priceDeltaMinor: 500000n,
            isDefault: false,
            sortOrder: 3,
          },
        ],
      },
      {
        id: `grp-${prefix}-soup`,
        menuItemId: itemId,
        key: 'soup',
        name: 'Canh',
        selectionType: 'boolean',
        isRequired: false,
        minSelections: 0,
        maxSelections: 1,
        sortOrder: 2,
        options: [
          {
            id: `opt-${prefix}-soup-yes`,
            key: 'yes',
            name: 'Có canh',
            kitchenLabel: '+ Canh',
            priceDeltaMinor: 0n,
            isDefault: false,
            sortOrder: 1,
          },
          {
            id: `opt-${prefix}-soup-no`,
            key: 'no',
            name: 'Không canh',
            kitchenLabel: 'Không canh',
            priceDeltaMinor: 0n,
            isDefault: true,
            sortOrder: 2,
          },
        ],
      },
      {
        id: `grp-${prefix}-toppings`,
        menuItemId: itemId,
        key: 'toppings',
        name: 'Topping thêm',
        selectionType: 'multi_select',
        isRequired: false,
        minSelections: 0,
        maxSelections: 3,
        sortOrder: 3,
        options: [
          {
            id: `opt-${prefix}-egg`,
            key: 'egg',
            name: 'Thêm trứng',
            kitchenLabel: '+ Trứng',
            priceDeltaMinor: 800000n,
            isDefault: false,
            sortOrder: 1,
          },
          {
            id: `opt-${prefix}-chicken`,
            key: 'chicken',
            name: 'Thêm gà',
            kitchenLabel: '+ Gà',
            priceDeltaMinor: 1500000n,
            isDefault: false,
            sortOrder: 2,
          },
          {
            id: `opt-${prefix}-cha`,
            key: 'cha',
            name: 'Thêm chả',
            kitchenLabel: '+ Chả',
            priceDeltaMinor: 1200000n,
            isDefault: false,
            sortOrder: 3,
          },
        ],
      },
    ],
  };
}

async function deleteCustomizationsForItems(
  prisma: PrismaClient,
  itemIds: string[],
): Promise<void> {
  if (itemIds.length === 0) return;
  const groups = await prisma.customization_group.findMany({
    where: { menu_item_id: { in: itemIds } },
    select: { id: true },
  });
  const groupIds = groups.map((g) => g.id);
  if (groupIds.length > 0) {
    await prisma.customization_option.deleteMany({
      where: { group_id: { in: groupIds } },
    });
    await prisma.customization_group.deleteMany({
      where: { id: { in: groupIds } },
    });
  }
}

async function tryDeleteOrDeactivateItem(
  prisma: PrismaClient,
  itemId: string,
): Promise<void> {
  const cartRefs = await prisma.session_cart_item.count({
    where: { menu_item_id: itemId },
  });
  const batchRefs = await prisma.batch_item.count({
    where: { menu_item_id: itemId },
  });
  const orderRefs = await prisma.order_line.count({
    where: { menu_item_id: itemId },
  });

  if (cartRefs + batchRefs + orderRefs === 0) {
    await deleteCustomizationsForItems(prisma, [itemId]);
    await prisma.menuItem.deleteMany({ where: { id: itemId } });
    // eslint-disable-next-line no-console
    console.log(`Deleted obsolete item ${itemId}`);
    return;
  }

  await prisma.menuItem.updateMany({
    where: { id: itemId },
    data: { isActive: false, availability: 'out_of_stock' },
  });
  // eslint-disable-next-line no-console
  console.log(`Deactivated obsolete item ${itemId} (FK refs present)`);
}

async function main(): Promise<void> {
  const prisma = new PrismaClient();
  const now = new Date();

  try {
    const restaurant = await prisma.restaurant.findUnique({
      where: { id: RID },
    });
    if (!restaurant) {
      throw new Error(`Restaurant ${RID} not found. Apply schema seed first.`);
    }

    const existingItems = await prisma.menuItem.findMany({
      where: { restaurantId: RID },
      select: { id: true },
    });
    const existingIds = existingItems.map((i) => i.id);
    const obsoleteIds = existingIds.filter((id) => !DEMO_ITEM_IDS.includes(id));

    // Clear customizations for demo items before re-upsert (idempotent).
    await deleteCustomizationsForItems(prisma, [...DEMO_ITEM_IDS]);

    for (const id of obsoleteIds) {
      await tryDeleteOrDeactivateItem(prisma, id);
    }

    // Deactivate old categories not in Flutter seed (e.g. cat-mains).
    await prisma.menuCategory.updateMany({
      where: {
        restaurantId: RID,
        id: { notIn: CATEGORIES.map((c) => c.id) },
      },
      data: { isActive: false, updatedAt: now },
    });

    for (const cat of CATEGORIES) {
      await prisma.menuCategory.upsert({
        where: { id: cat.id },
        create: {
          id: cat.id,
          restaurantId: RID,
          name: cat.name,
          sortOrder: cat.sortOrder,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        },
        update: {
          name: cat.name,
          sortOrder: cat.sortOrder,
          isActive: true,
          updatedAt: now,
        },
      });
    }

    for (const item of RICE_ITEMS) {
      await prisma.menuItem.upsert({
        where: { id: item.id },
        create: {
          id: item.id,
          restaurantId: RID,
          categoryId: 'cat-rice',
          name: item.name,
          description: item.description,
          basePriceMinor: item.priceMinor,
          currencyCode: CURRENCY,
          availability: 'available',
          sortOrder: item.sortOrder,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        },
        update: {
          categoryId: 'cat-rice',
          name: item.name,
          description: item.description,
          basePriceMinor: item.priceMinor,
          currencyCode: CURRENCY,
          availability: 'available',
          sortOrder: item.sortOrder,
          isActive: true,
          updatedAt: now,
        },
      });

      const { groups } = riceGroups(item.id, item.prefix);
      for (const group of groups) {
        await prisma.customization_group.create({
          data: {
            id: group.id,
            menu_item_id: group.menuItemId,
            group_key: group.key,
            name: group.name,
            selection_type: group.selectionType,
            is_required: group.isRequired,
            min_selections: group.minSelections,
            max_selections: group.maxSelections,
            sort_order: group.sortOrder,
            is_active: true,
            created_at: now,
            updated_at: now,
          },
        });
        for (const opt of group.options) {
          await prisma.customization_option.create({
            data: {
              id: opt.id,
              group_id: group.id,
              option_key: opt.key,
              name: opt.name,
              kitchen_label: opt.kitchenLabel,
              price_delta_minor: opt.priceDeltaMinor,
              currency_code: CURRENCY,
              is_default: opt.isDefault,
              sort_order: opt.sortOrder,
              is_active: true,
              created_at: now,
              updated_at: now,
            },
          });
        }
      }
    }

    for (const item of DRINK_ITEMS) {
      await prisma.menuItem.upsert({
        where: { id: item.id },
        create: {
          id: item.id,
          restaurantId: RID,
          categoryId: 'cat-drinks',
          name: item.name,
          description: null,
          basePriceMinor: item.priceMinor,
          currencyCode: CURRENCY,
          availability: 'available',
          sortOrder: item.sortOrder,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        },
        update: {
          categoryId: 'cat-drinks',
          name: item.name,
          description: null,
          basePriceMinor: item.priceMinor,
          currencyCode: CURRENCY,
          availability: 'available',
          sortOrder: item.sortOrder,
          isActive: true,
          updatedAt: now,
        },
      });
    }

    // eslint-disable-next-line no-console
    console.log(
      `Demo menu seeded for ${RID}: ${CATEGORIES.length} categories, ` +
        `${DEMO_ITEM_IDS.length} items (Flutter DemoMenuSeed aligned)`,
    );
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((err) => {
  // eslint-disable-next-line no-console
  console.error(err);
  process.exit(1);
});
