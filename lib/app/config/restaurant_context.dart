import 'package:flutter/foundation.dart';

import '../../core/theme/restaurant_brand.dart';

/// Active tenant for this app process (API restaurant id + guest brand).
///
/// Configure with `--dart-define=RESTAURANT_ID=...` (default: The Forest demo).
@immutable
final class RestaurantContext {
  const RestaurantContext({
    required this.restaurantId,
    required this.brand,
  });

  /// Backend restaurant primary key / slug used in `/restaurants/{id}/...`.
  final String restaurantId;

  /// Guest-facing brand signals (name, tagline).
  final RestaurantBrand brand;

  /// Pilot tenant matching Nest seed data.
  static const theForest = RestaurantContext(
    restaurantId: 'demo-restaurant',
    brand: RestaurantBrand.theForest,
  );

  /// Resolves compile-time tenant; falls back to [theForest].
  static RestaurantContext fromEnvironment() {
    const id = String.fromEnvironment(
      'RESTAURANT_ID',
      defaultValue: 'demo-restaurant',
    );
    if (id == theForest.restaurantId || id.isEmpty) {
      return theForest;
    }
    return RestaurantContext(
      restaurantId: id,
      brand: RestaurantBrand(
        id: id,
        displayName: id,
        shortName: id,
      ),
    );
  }
}
