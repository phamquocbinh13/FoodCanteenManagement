import 'package:get_it/get_it.dart';

import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/get_it_auth_token_provider.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/shared_preferences_local_storage.dart';
import '../../../core/time/time_provider.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../domain/events/domain_events.dart';
import '../../config/app_config.dart';
import '../../config/restaurant_context.dart';
import '../../../core/theme/restaurant_brand.dart';

/// Registers cross-cutting infrastructure (remote production path).
abstract final class CoreModule {
  static Future<void> register(GetIt sl, AppConfig config) async {
    sl.registerLazySingleton<AppConfig>(() => config);
    sl.registerLazySingleton<RestaurantContext>(() => config.restaurant);
    RestaurantBrand.current = config.restaurant.brand;

    sl.registerLazySingleton<AppLogger>(
      () => ConsoleAppLogger(
        minLevel: config.enableLogging ? LogLevel.debug : LogLevel.warning,
      ),
    );

    sl.registerLazySingleton<Clock>(() => const SystemClock());

    sl.registerLazySingleton<TimeProvider>(
      () => ClockTimeProvider(sl<Clock>()),
    );

    sl.registerLazySingleton<IdGenerator>(() => UuidGenerator());

    final storage = await SharedPreferencesLocalStorage.create();
    sl.registerLazySingleton<LocalStorage>(() => storage);

    sl.registerLazySingleton<CustomerSessionLocalDataSource>(
      () => CustomerSessionLocalDataSourceImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<ApiClient>(
      () => HttpApiClient(
        baseUrl: config.apiBaseUrl,
        logger: sl<AppLogger>(),
        tokenProvider: GetItAuthTokenProvider(sl),
      ),
    );

    sl.registerLazySingleton<DomainEventPublisher>(
      () => const NoOpDomainEventPublisher(),
    );

    await sl<LocalStorage>().init();
  }
}
