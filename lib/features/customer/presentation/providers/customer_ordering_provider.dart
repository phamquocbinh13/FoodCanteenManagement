import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../controllers/customer_ordering_controller.dart';

final customerOrderingControllerProvider =
    ChangeNotifierProvider<CustomerOrderingController>((ref) {
  return CustomerOrderingController(
    getMenuCatalog: sl(),
    getMenuItemDetail: sl(),
    addToCart: sl(),
    getSessionCart: sl(),
    confirmBatch: sl(),
    getSessionBill: sl(),
  );
});
