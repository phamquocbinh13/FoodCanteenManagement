import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/restaurant_context.dart';
import '../../../../app/di/injection.dart';
import '../controllers/kitchen_controller.dart';

final kitchenControllerProvider =
    ChangeNotifierProvider<KitchenController>((ref) {
  return KitchenController(
    restaurantId: sl<RestaurantContext>().restaurantId,
    getKitchenQueue: sl(),
    completeBatchItem: sl(),
    toggleMenuAvailability: sl(),
    getKitchenMenuPanel: sl(),
  );
});
