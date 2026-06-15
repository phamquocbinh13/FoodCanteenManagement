import 'package:get_it/get_it.dart';

import '../../../core/clock/clock.dart';
import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/lifecycle/app_lifecycle_service.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/stub_api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/shared_preferences_local_storage.dart';
import '../../../core/time/time_provider.dart';
import '../../../domain/events/domain_events.dart';
import '../../config/app_config.dart';

/// Registers cross-cutting infrastructure services.
abstract final class CoreModule {
  static Future<void> register(GetIt sl, AppConfig config) async {
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

    sl.registerLazySingleton<ApiClient>(
      () => StubApiClient(logger: sl<AppLogger>()),
    );

    sl.registerLazySingleton<AppLifecycleService>(
      () => StubAppLifecycleService(),
    );

    sl.registerLazySingleton<ConnectivityService>(
      () => StubConnectivityService(),
    );

    sl.registerLazySingleton<DomainEventPublisher>(
      () => const NoOpDomainEventPublisher(),
    );

    await sl<LocalStorage>().init();
  }
}
