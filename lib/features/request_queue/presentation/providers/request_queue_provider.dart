import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../controllers/request_queue_controller.dart';

export '../controllers/request_queue_controller.dart';

final requestQueueControllerProvider =
    ChangeNotifierProvider<RequestQueueController>((ref) {
  final controller = RequestQueueController(
    listPending: sl(),
    handleRequest: sl(),
  );
  controller.refresh();
  return controller;
});
