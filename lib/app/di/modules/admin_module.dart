import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../../../data/repositories/analytics/remote_analytics_repository.dart';
import '../../../domain/repositories/analytics_repository.dart';

/// Admin module shell. Sprint 12.
abstract final class AdminModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<AnalyticsRepository>(
      () => RemoteAnalyticsRepository(apiClient: sl<ApiClient>()),
    );
  }
}
