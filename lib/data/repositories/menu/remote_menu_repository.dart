import '../../../application/session/session_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/customization_group.dart';
import '../../../domain/entities/customization_option.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/menu_item_availability_history.dart';
import '../../../domain/repositories/menu_repository.dart';

/// [MenuRepository] backed by NestJS Menu APIs.
final class RemoteMenuRepository implements MenuRepository {
  RemoteMenuRepository({
    required ApiClient apiClient,
    String defaultRestaurantId = SessionEngineConstants.demoRestaurantId,
  })  : _api = apiClient,
        _defaultRestaurantId = defaultRestaurantId;

  final ApiClient _api;
  final String _defaultRestaurantId;

  final Map<String, String> _itemRestaurantIds = {};
  final Map<String, List<CustomizationGroup>> _groupsByItemId = {};
  final Map<String, List<CustomizationOption>> _optionsByGroupId = {};
  final Map<String, int> _catalogVersions = {};

  MenuItem _parseItem(Map<String, dynamic> json) {
    final item = RemoteJson.parse(json, MenuItem.fromJson);
    _itemRestaurantIds[item.id] = item.restaurantId;
    return item;
  }

  MenuCategory _parseCategory(Map<String, dynamic> json) =>
      RemoteJson.parse(json, MenuCategory.fromJson);

  CustomizationGroup _parseGroup(Map<String, dynamic> json) {
    final snake = RemoteJson.normalize(json);
    final optionsJson = (snake.remove('options') as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final group = CustomizationGroup.fromJson(snake);
    final options = optionsJson.map(CustomizationOption.fromJson).toList();
    _optionsByGroupId[group.id] = options;
    return group;
  }

  Future<void> _loadItemDetail({
    required String restaurantId,
    required String menuItemId,
  }) async {
    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/restaurants/$restaurantId/menu/items/$menuItemId',
        requiresAuth: false,
      ),
    );
    final data = response.data;
    final itemJson = data['item'] as Map<String, dynamic>;
    _parseItem(itemJson);
    final groups = (data['groups'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parseGroup)
        .toList();
    _groupsByItemId[menuItemId] = groups;
  }

  String _restaurantIdForItem(String menuItemId) =>
      _itemRestaurantIds[menuItemId] ?? _defaultRestaurantId;

  @override
  Future<List<MenuCategory>> listCategories(String restaurantId) async {
    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/restaurants/$restaurantId/menu',
        requiresAuth: false,
      ),
    );
    final data = response.data;
    _catalogVersions[restaurantId] = (data['menuVersion'] as num?)?.toInt() ?? 0;
    for (final raw in (data['items'] as List<dynamic>? ?? [])) {
      _parseItem(raw as Map<String, dynamic>);
    }
    return (data['categories'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parseCategory)
        .toList();
  }

  @override
  Future<List<MenuItem>> listAvailableItems(String restaurantId) async {
    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/restaurants/$restaurantId/menu',
        requiresAuth: false,
      ),
    );
    final data = response.data;
    _catalogVersions[restaurantId] = (data['menuVersion'] as num?)?.toInt() ?? 0;
    return (data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parseItem)
        .toList();
  }

  @override
  Future<List<MenuItem>> listKitchenItems(String restaurantId) async {
    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(path: '/restaurants/$restaurantId/kitchen/menu'),
    );
    return (response.data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parseItem)
        .toList();
  }

  @override
  Future<MenuItem?> findItemById({
    required String restaurantId,
    required String menuItemId,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/menu/items/$menuItemId',
          requiresAuth: false,
        ),
      );
      final data = response.data;
      final item = _parseItem(data['item'] as Map<String, dynamic>);
      final groups = (data['groups'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parseGroup)
          .toList();
      _groupsByItemId[menuItemId] = groups;
      return item;
    } catch (e) {
      final failure = failureFromException(e);
      if (failure.code == 'MENU_ITEM_NOT_FOUND' ||
          failure.code == 'NOT_FOUND') {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<MenuItem> updateAvailability(MenuItem item) async {
    var current = await findItemById(
      restaurantId: item.restaurantId,
      menuItemId: item.id,
    );
    if (current == null) {
      throw StateError('Menu item not found: ${item.id}');
    }

    // Backend toggle flips available ↔ out_of_stock; call until desired.
    var guard = 0;
    while (current!.availability != item.availability && guard < 2) {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${item.restaurantId}/menu/items/${item.id}/toggle-availability',
          method: HttpMethod.post,
          body: const {},
        ),
      );
      current = _parseItem(response.data);
      _catalogVersions.remove(item.restaurantId);
      guard++;
    }
    return current;
  }

  @override
  Future<List<CustomizationGroup>> getGroupsByMenuItemId(
    String menuItemId,
  ) async {
    final cached = _groupsByItemId[menuItemId];
    if (cached != null) return List.unmodifiable(cached);

    await _loadItemDetail(
      restaurantId: _restaurantIdForItem(menuItemId),
      menuItemId: menuItemId,
    );
    return List.unmodifiable(_groupsByItemId[menuItemId] ?? const []);
  }

  @override
  Future<List<CustomizationOption>> getOptionsByGroupId(String groupId) async {
    final cached = _optionsByGroupId[groupId];
    if (cached != null) return List.unmodifiable(cached);

    // Options are loaded with group detail; without item context return empty.
    return const [];
  }

  @override
  Future<MenuItemAvailabilityHistory> recordAvailabilityHistory(
    MenuItemAvailabilityHistory history,
  ) async {
    // Backend records history inside toggle-availability.
    return history;
  }

  @override
  Future<int> getCatalogVersion(String restaurantId) async {
    final cached = _catalogVersions[restaurantId];
    if (cached != null) return cached;

    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(
        path: '/restaurants/$restaurantId/menu',
        requiresAuth: false,
      ),
    );
    final version = (response.data['menuVersion'] as num?)?.toInt() ?? 0;
    _catalogVersions[restaurantId] = version;
    return version;
  }
}
