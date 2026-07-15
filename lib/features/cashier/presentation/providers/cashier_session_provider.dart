import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../app/di/injection.dart';
import '../../../../application/usecases/payment/close_session_with_payment_use_case.dart';
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
    closeWithPayment: GetIt.I.isRegistered<CloseSessionWithPaymentUseCase>()
        ? sl<CloseSessionWithPaymentUseCase>()
        : null,
  );
  controller.restore();
  return controller;
});
