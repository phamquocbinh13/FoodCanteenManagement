import '../entities/restaurant_table.dart';

/// Persistence contract for [RestaurantTable] floor management.
abstract interface class TableRepository {
  Future<RestaurantTable?> findById({
    required String restaurantId,
    required String tableId,
  });

  Future<List<RestaurantTable>> listByRestaurant(String restaurantId);

  Future<RestaurantTable> update(RestaurantTable table);
}
