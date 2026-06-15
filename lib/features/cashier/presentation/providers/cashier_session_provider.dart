import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../controllers/cashier_session_controller.dart';

export '../controllers/cashier_session_controller.dart';

final cashierSessionControllerProvider =
    ChangeNotifierProvider<CashierSessionController>((ref) {
  final controller = CashierSessionController(
    createSession: sl(),
    closeSession: sl(),
    markWaitingPayment: sl(),
    restoreSession: sl(),
    getCashierBatchSummaries: sl(),
  );
  controller.restore();
  return controller;
});
