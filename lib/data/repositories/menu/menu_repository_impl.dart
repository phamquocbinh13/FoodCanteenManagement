import '../../../domain/entities/customization_group.dart';
import '../../../domain/entities/customization_option.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/menu_item_availability_history.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../datasources/ordering/ordering_store.dart';

/// In-memory menu repository backed by [OrderingStore].
final class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl({
    required OrderingStore store,
    MenuDomainService? menuDomainService,
  })  : _store = store,
        _menuService = menuDomainService ?? const MenuDomainService();

  final OrderingStore _store;
  final MenuDomainService _menuService;

  @override
  Future<List<MenuCategory>> listCategories(String restaurantId) async {
    return _store.categories.values
        .where((c) => c.restaurantId == restaurantId && c.isActive)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<List<MenuItem>> listAvailableItems(String restaurantId) async {
    return _store.menuItems.values
        .where(
          (item) =>
              item.restaurantId == restaurantId &&
              _menuService.isVisibleToCustomer(item),
        )
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<MenuItem?> findItemById({
    required String restaurantId,
    required String menuItemId,
  }) async {
    final item = _store.menuItems[menuItemId];
    if (item == null || item.restaurantId != restaurantId) return null;
    return item;
  }

  @override
  Future<MenuItem> updateAvailability(MenuItem item) async {
    final updated = _menuService.setAvailability(
      item: item,
      availability: item.availability,
    );
    _store.menuItems[item.id] = updated;
    _store.menuCachedAt = null;
    return updated;
  }

  @override
  Future<List<CustomizationGroup>> getGroupsByMenuItemId(
    String menuItemId,
  ) async {
    return _store.customizationGroups.values
        .where((g) => g.menuItemId == menuItemId && g.isActive)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<List<CustomizationOption>> getOptionsByGroupId(String groupId) async {
    return _store.customizationOptions.values
        .where((o) => o.groupId == groupId && o.isActive)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<MenuItemAvailabilityHistory> recordAvailabilityHistory(
    MenuItemAvailabilityHistory history,
  ) async {
    return history;
  }
}
