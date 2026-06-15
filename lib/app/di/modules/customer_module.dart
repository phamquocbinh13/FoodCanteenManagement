import 'package:get_it/get_it.dart';

import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/storage/local_storage.dart';
import '../../../application/usecases/session/join_session_use_case.dart';
import '../../../application/usecases/session/validate_session_use_case.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../domain/events/domain_events.dart';
import '../../../features/customer/presentation/controllers/customer_session_controller.dart';

abstract final class CustomerModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<CustomerSessionLocalDataSource>(
      () => CustomerSessionLocalDataSourceImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton(
      () => CustomerSessionController(
        joinSession: sl<JoinSessionUseCase>(),
        validateSession: sl<ValidateSessionUseCase>(),
        local: sl<CustomerSessionLocalDataSource>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
        now: () => sl<Clock>().now(),
      ),
    );
  }
}
