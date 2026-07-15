import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/restaurant_context.dart';
import '../../../../app/di/injection.dart';
import '../controllers/request_queue_controller.dart';

export '../controllers/request_queue_controller.dart';

final requestQueueControllerProvider =
    ChangeNotifierProvider<RequestQueueController>((ref) {
  final controller = RequestQueueController(
    restaurantId: sl<RestaurantContext>().restaurantId,
    listPending: sl(),
    handleRequest: sl(),
  );
  controller.refresh();
  return controller;
});
