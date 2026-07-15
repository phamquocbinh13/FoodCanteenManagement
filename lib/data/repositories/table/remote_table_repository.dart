import '../../../core/network/api_client.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/restaurant_table.dart';
import '../../../domain/repositories/table_repository.dart';

/// [TableRepository] backed by NestJS restaurant tables API.
final class RemoteTableRepository implements TableRepository {
  RemoteTableRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  RestaurantTable _parse(Map<String, dynamic> json) =>
      RemoteJson.parse(json, RestaurantTable.fromJson);

  @override
  Future<RestaurantTable?> findById({
    required String restaurantId,
    required String tableId,
  }) async {
    final tables = await listByRestaurant(restaurantId);
    for (final table in tables) {
      if (table.id == tableId) return table;
    }
    return null;
  }

  @override
  Future<List<RestaurantTable>> listByRestaurant(String restaurantId) async {
    final response = await _api.send<Map<String, dynamic>>(
      ApiRequest(path: '/restaurants/$restaurantId/tables'),
    );
    final items = (response.data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parse)
        .toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  @override
  Future<RestaurantTable> update(RestaurantTable table) async {
    throw UnsupportedError(
      'Table updates are owned by session/payment transactions on the server.',
    );
  }
}
