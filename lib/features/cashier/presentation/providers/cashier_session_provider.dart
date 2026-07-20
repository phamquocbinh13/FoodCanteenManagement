import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/config/restaurant_context.dart';
import '../../../../app/di/injection.dart';
import '../controllers/cashier_session_controller.dart';

export '../controllers/cashier_session_controller.dart';

final cashierSessionControllerProvider =
    ChangeNotifierProvider<CashierSessionController>((ref) {
  final controller = CashierSessionController(
    restaurantId: sl<RestaurantContext>().restaurantId,
    createSession: sl(),
    closeSession: sl(),
    markWaitingPayment: sl(),
    restoreSession: sl(),
    getCashierBatchSummaries: sl(),
    listTables: sl(),
    getSessionBill: sl(),
    listSessionRequests: sl(),
    reissueSessionToken: sl(),
    closeWithPayment: sl(),
  );
  controller.restore();
  controller.startPolling();
  return controller;
});
