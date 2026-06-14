import '../../../domain/entities/customization_group.dart';
import '../../../domain/entities/customization_option.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/menu_item_availability_history.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../datasources/menu/menu_datasource.dart';

final class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl({required MenuRemoteDataSource remote})
      : _remote = remote;

  // ignore: unused_field
  final MenuRemoteDataSource _remote;

  Never _notImplemented(String method) =>
      throw UnimplementedError('MenuRepositoryImpl.$method');

  @override
  Future<List<MenuCategory>> listCategories(String restaurantId) =>
      _notImplemented('listCategories');

  @override
  Future<List<MenuItem>> listAvailableItems(String restaurantId) =>
      _notImplemented('listAvailableItems');

  @override
  Future<MenuItem?> findItemById({
    required String restaurantId,
    required String menuItemId,
  }) =>
      _notImplemented('findItemById');

  @override
  Future<MenuItem> updateAvailability(MenuItem item) =>
      _notImplemented('updateAvailability');

  @override
  Future<List<CustomizationGroup>> getGroupsByMenuItemId(String menuItemId) =>
      _notImplemented('getGroupsByMenuItemId');

  @override
  Future<List<CustomizationOption>> getOptionsByGroupId(String groupId) =>
      _notImplemented('getOptionsByGroupId');

  @override
  Future<MenuItemAvailabilityHistory> recordAvailabilityHistory(
    MenuItemAvailabilityHistory history,
  ) =>
      _notImplemented('recordAvailabilityHistory');
}
