import 'package:get_it/get_it.dart';

import '../../../data/datasources/ordering/ordering_store.dart';

/// Registers shared in-memory ordering store (menu, cart, batch, session).
abstract final class OrderingModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<OrderingStore>(() => OrderingStore());
  }
}
