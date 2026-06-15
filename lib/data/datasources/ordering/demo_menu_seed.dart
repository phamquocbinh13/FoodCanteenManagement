import '../../../application/session/session_constants.dart';
import '../../../core/clock/clock.dart';
import '../../../domain/entities/customization_group.dart';
import '../../../domain/entities/customization_option.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/value_objects/money.dart';
import 'ordering_store.dart';

/// Seeds demo menu catalog for Sprint 5 ordering flow.
abstract final class DemoMenuSeed {
  static const currency = 'USD';

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
      required double price,
      String? description,
      String? imageUrl,
      int sortOrder = 0,
    }) {
      store.menuItems[id] = MenuItem(
        id: id,
        restaurantId: rid,
        categoryId: categoryId,
        name: name,
        description: description,
        basePrice: Money.fromDecimal(amount: price, currencyCode: currency),
        imageUrl: imageUrl,
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
      double priceDelta = 0,
      bool isDefault = false,
    }) {
      store.customizationOptions[id] = CustomizationOption(
        id: id,
        groupId: groupId,
        key: key,
        name: name,
        kitchenLabel: kitchenLabel ?? name,
        priceDelta: Money.fromDecimal(amount: priceDelta, currencyCode: currency),
        isDefault: isDefault,
        createdAt: now,
        updatedAt: now,
      );
    }

    category('cat-rice', 'Rice Dishes', 1);
    category('cat-noodles', 'Noodles', 2);
    category('cat-drinks', 'Drinks', 3);

    item(
      id: 'item-fried-rice',
      categoryId: 'cat-rice',
      name: 'Fried Rice',
      price: 8.50,
      description: 'Classic wok-fried rice with egg and vegetables',
      sortOrder: 1,
    );
    group(
      id: 'grp-rice-size',
      menuItemId: 'item-fried-rice',
      key: 'rice_size',
      name: 'Rice Size',
      type: CustomizationSelectionType.singleSelect,
      required: true,
      min: 1,
      max: 1,
    );
    option(
      id: 'opt-normal',
      groupId: 'grp-rice-size',
      key: 'normal',
      name: 'Normal',
      isDefault: true,
    );
    option(id: 'opt-small', groupId: 'grp-rice-size', key: 'small', name: 'Small');
    option(
      id: 'opt-large',
      groupId: 'grp-rice-size',
      key: 'large',
      name: 'Large',
      priceDelta: 1.50,
    );
    group(
      id: 'grp-soup',
      menuItemId: 'item-fried-rice',
      key: 'soup',
      name: 'Soup',
      type: CustomizationSelectionType.boolean,
    );
    option(
      id: 'opt-soup-yes',
      groupId: 'grp-soup',
      key: 'yes',
      name: 'Yes',
      kitchenLabel: '+ Soup',
    );
    option(
      id: 'opt-soup-no',
      groupId: 'grp-soup',
      key: 'no',
      name: 'No',
      kitchenLabel: 'No Soup',
      isDefault: true,
    );
    group(
      id: 'grp-toppings',
      menuItemId: 'item-fried-rice',
      key: 'toppings',
      name: 'Toppings',
      type: CustomizationSelectionType.multiSelect,
      min: 0,
      max: 3,
    );
    option(
      id: 'opt-chicken',
      groupId: 'grp-toppings',
      key: 'chicken',
      name: 'Chicken',
      priceDelta: 2.00,
    );
    option(
      id: 'opt-egg',
      groupId: 'grp-toppings',
      key: 'egg',
      name: 'Egg',
      priceDelta: 1.00,
    );
    option(
      id: 'opt-sausage',
      groupId: 'grp-toppings',
      key: 'sausage',
      name: 'Sausage',
      priceDelta: 1.50,
    );

    item(
      id: 'item-pho',
      categoryId: 'cat-noodles',
      name: 'Beef Pho',
      price: 10.00,
      description: 'Slow-simmered broth with rice noodles',
      sortOrder: 1,
    );

    item(
      id: 'item-iced-tea',
      categoryId: 'cat-drinks',
      name: 'Iced Tea',
      price: 2.50,
      sortOrder: 1,
    );

    store.menuCachedAt = now;
  }
}
