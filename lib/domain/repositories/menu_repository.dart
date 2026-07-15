import '../entities/customization_group.dart';
import '../entities/customization_option.dart';
import '../entities/menu_category.dart';
import '../entities/menu_item.dart';
import '../entities/menu_item_availability_history.dart';

/// Persistence contract for menu catalog.
abstract interface class MenuRepository {
  Future<List<MenuCategory>> listCategories(String restaurantId);

  Future<List<MenuItem>> listAvailableItems(String restaurantId);

  /// All active catalog items for kitchen availability panel.
  Future<List<MenuItem>> listKitchenItems(String restaurantId);

  Future<MenuItem?> findItemById({
    required String restaurantId,
    required String menuItemId,
  });

  Future<MenuItem> updateAvailability(MenuItem item);

  Future<List<CustomizationGroup>> getGroupsByMenuItemId(String menuItemId);

  Future<List<CustomizationOption>> getOptionsByGroupId(String groupId);

  Future<MenuItemAvailabilityHistory> recordAvailabilityHistory(
    MenuItemAvailabilityHistory history,
  );

  /// Monotonic catalog version for client cache invalidation.
  Future<int> getCatalogVersion(String restaurantId);
}
