import 'package:food_canteen_management/domain/entities/restaurant_table.dart';
import 'package:food_canteen_management/domain/repositories/table_repository.dart';
import 'ordering_store.dart';

/// In-memory [TableRepository] backed by [OrderingStore].
final class TableRepositoryImpl implements TableRepository {
  TableRepositoryImpl({required OrderingStore store}) : _store = store;

  final OrderingStore _store;

  @override
  Future<RestaurantTable?> findById({
    required String restaurantId,
    required String tableId,
  }) async {
    final table = _store.tables[tableId];
    if (table == null || table.restaurantId != restaurantId) return null;
    return table;
  }

  @override
  Future<List<RestaurantTable>> listByRestaurant(String restaurantId) async {
    final tables = _store.tables.values
        .where((t) => t.restaurantId == restaurantId && t.isActive)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return tables;
  }

  @override
  Future<RestaurantTable> update(RestaurantTable table) async {
    _store.tables[table.id] = table;
    return table;
  }
}
