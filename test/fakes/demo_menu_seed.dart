import 'package:food_canteen_management/application/session/session_constants.dart';
import 'package:food_canteen_management/core/clock/clock.dart';
import 'package:food_canteen_management/domain/entities/customization_group.dart';
import 'package:food_canteen_management/domain/entities/customization_option.dart';
import 'package:food_canteen_management/domain/entities/menu_category.dart';
import 'package:food_canteen_management/domain/entities/menu_item.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/value_objects/money.dart';
import 'ordering_store.dart';

/// Seeds demo menu catalog for Sprint 5 ordering flow.
abstract final class DemoMenuSeed {
  static const currency = 'VND';

  static void seed(OrderingStore store, Clock clock) {
    if (store.categories.isNotEmpty) return;
    final now = clock.now();
    const rid = SessionEngineConstants.demoRestaurantId;

    void category(String id, String name, int order) {
      store.categories[id] = MenuCategory(
        id: id,
        restaurantId: rid,
        name: name,
        sortOrder: order,
        createdAt: now,
        updatedAt: now,
      );
    }

    void item({
      required String id,
      required String categoryId,
      required String name,
      required int priceVnd,
      String? description,
      int sortOrder = 0,
    }) {
      store.menuItems[id] = MenuItem(
        id: id,
        restaurantId: rid,
        categoryId: categoryId,
        name: name,
        description: description,
        basePrice: Money(amountMinor: priceVnd * 100, currencyCode: currency),
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      );
    }

    void group({
      required String id,
      required String menuItemId,
      required String key,
      required String name,
      required CustomizationSelectionType type,
      bool required = false,
      int min = 0,
      int max = 1,
    }) {
      store.customizationGroups[id] = CustomizationGroup(
        id: id,
        menuItemId: menuItemId,
        key: key,
        name: name,
        selectionType: type,
        isRequired: required,
        minSelections: min,
        maxSelections: max,
        createdAt: now,
        updatedAt: now,
      );
    }

    void option({
      required String id,
      required String groupId,
      required String key,
      required String name,
      String? kitchenLabel,
      int priceDeltaVnd = 0,
      bool isDefault = false,
    }) {
      store.customizationOptions[id] = CustomizationOption(
        id: id,
        groupId: groupId,
        key: key,
        name: name,
        kitchenLabel: kitchenLabel ?? name,
        priceDelta: Money(
          amountMinor: priceDeltaVnd * 100,
          currencyCode: currency,
        ),
        isDefault: isDefault,
        createdAt: now,
        updatedAt: now,
      );
    }

    void attachRiceCustomizations(String itemId, String prefix) {
      group(
        id: 'grp-$prefix-size',
        menuItemId: itemId,
        key: 'rice_size',
        name: 'Cỡ cơm',
        type: CustomizationSelectionType.singleSelect,
        required: true,
        min: 1,
        max: 1,
      );
      option(
        id: 'opt-$prefix-less',
        groupId: 'grp-$prefix-size',
        key: 'less',
        name: 'Ít cơm',
        kitchenLabel: 'Ít cơm',
      );
      option(
        id: 'opt-$prefix-normal',
        groupId: 'grp-$prefix-size',
        key: 'normal',
        name: 'Bình thường',
        kitchenLabel: 'Cơm bình thường',
        isDefault: true,
      );
      option(
        id: 'opt-$prefix-more',
        groupId: 'grp-$prefix-size',
        key: 'more',
        name: 'Nhiều cơm',
        kitchenLabel: 'Nhiều cơm',
        priceDeltaVnd: 5000,
      );

      group(
        id: 'grp-$prefix-soup',
        menuItemId: itemId,
        key: 'soup',
        name: 'Canh',
        type: CustomizationSelectionType.boolean,
      );
      option(
        id: 'opt-$prefix-soup-yes',
        groupId: 'grp-$prefix-soup',
        key: 'yes',
        name: 'Có canh',
        kitchenLabel: '+ Canh',
      );
      option(
        id: 'opt-$prefix-soup-no',
        groupId: 'grp-$prefix-soup',
        key: 'no',
        name: 'Không canh',
        kitchenLabel: 'Không canh',
        isDefault: true,
      );

      group(
        id: 'grp-$prefix-toppings',
        menuItemId: itemId,
        key: 'toppings',
        name: 'Topping thêm',
        type: CustomizationSelectionType.multiSelect,
        min: 0,
        max: 3,
      );
      option(
        id: 'opt-$prefix-egg',
        groupId: 'grp-$prefix-toppings',
        key: 'egg',
        name: 'Thêm trứng',
        kitchenLabel: '+ Trứng',
        priceDeltaVnd: 8000,
      );
      option(
        id: 'opt-$prefix-chicken',
        groupId: 'grp-$prefix-toppings',
        key: 'chicken',
        name: 'Thêm gà',
        kitchenLabel: '+ Gà',
        priceDeltaVnd: 15000,
      );
      option(
        id: 'opt-$prefix-cha',
        groupId: 'grp-$prefix-toppings',
        key: 'cha',
        name: 'Thêm chả',
        kitchenLabel: '+ Chả',
        priceDeltaVnd: 12000,
      );
    }

    category('cat-rice', '🍛 Rice', 1);
    category('cat-drinks', '🥤 Drinks', 2);

    item(
      id: 'item-curry-rice',
      categoryId: 'cat-rice',
      name: 'Cơm cà ri gà',
      description: 'Chicken Curry Rice',
      priceVnd: 45000,
      sortOrder: 1,
    );
    attachRiceCustomizations('item-curry-rice', 'curry');

    item(
      id: 'item-pork-roll-rice',
      categoryId: 'cat-rice',
      name: 'Cơm chả lá lốt',
      description: 'Grilled Pork Roll Rice',
      priceVnd: 42000,
      sortOrder: 2,
    );
    attachRiceCustomizations('item-pork-roll-rice', 'pork');

    item(
      id: 'item-mushroom-rice',
      categoryId: 'cat-rice',
      name: 'Cơm gà xào nấm',
      description: 'Chicken Mushroom Rice',
      priceVnd: 47000,
      sortOrder: 3,
    );
    attachRiceCustomizations('item-mushroom-rice', 'mushroom');

    item(
      id: 'item-braised-pork-rice',
      categoryId: 'cat-rice',
      name: 'Cơm trứng thịt kho tàu',
      description: 'Braised Pork Egg Rice',
      priceVnd: 43000,
      sortOrder: 4,
    );
    attachRiceCustomizations('item-braised-pork-rice', 'braised');

    item(
      id: 'item-fried-chicken-rice',
      categoryId: 'cat-rice',
      name: 'Cơm gà chiên giòn',
      description: 'Crispy Fried Chicken Rice',
      priceVnd: 49000,
      sortOrder: 5,
    );
    attachRiceCustomizations('item-fried-chicken-rice', 'fried');

    item(
      id: 'item-tra-da',
      categoryId: 'cat-drinks',
      name: 'Trà đá',
      priceVnd: 5000,
      sortOrder: 1,
    );
    item(
      id: 'item-coca',
      categoryId: 'cat-drinks',
      name: 'Coca Cola',
      priceVnd: 15000,
      sortOrder: 2,
    );
    item(
      id: 'item-pepsi',
      categoryId: 'cat-drinks',
      name: 'Pepsi',
      priceVnd: 15000,
      sortOrder: 3,
    );
    item(
      id: 'item-sprite',
      categoryId: 'cat-drinks',
      name: 'Sprite',
      priceVnd: 15000,
      sortOrder: 4,
    );

    store.menuVersion = 1;
    store.menuCachedAt = now;
  }
}
