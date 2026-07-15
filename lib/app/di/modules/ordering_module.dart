import 'package:get_it/get_it.dart';

import '../../../data/datasources/ordering/ordering_store.dart';
import '../../config/app_config.dart';

/// Registers shared in-memory ordering store for demo / local repositories only.
abstract final class OrderingModule {
  static void register(GetIt sl) {
    if (sl<AppConfig>().useRemoteBackend) {
      return;
    }
    sl.registerLazySingleton<OrderingStore>(() => OrderingStore());
  }
}
