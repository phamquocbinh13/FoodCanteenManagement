import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../../../../application/menu/kitchen_batch_ticket.dart';
import '../../../../application/usecases/batch/confirm_batch_use_case.dart';
import '../../../../application/usecases/use_case.dart';
import '../controllers/customer_ordering_controller.dart';

final customerOrderingControllerProvider =
    ChangeNotifierProvider<CustomerOrderingController>((ref) {
  return CustomerOrderingController(
    getMenuCatalog: sl(),
    getMenuItemDetail: sl(),
    addToCart: sl(),
    getSessionCart: sl(),
    updateCartItemQuantity: sl(),
    removeCartItem: sl(),
    editCartItem: sl(),
    clearSessionCart: sl(),
    confirmBatch: sl<UseCase<KitchenBatchTicket, ConfirmBatchParams>>(),
    getSessionBill: sl(),
    getSessionBatchProgress: sl(),
  );
});
