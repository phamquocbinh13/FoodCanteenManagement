import 'package:get_it/get_it.dart';

import '../../../application/policies/session_policy.dart';
import '../../../application/session/session_timeline_recorder.dart';
import '../../../application/usecases/session/close_session_use_case.dart';
import '../../../application/usecases/session/create_session_use_case.dart';
import '../../../application/usecases/session/join_session_use_case.dart';
import '../../../application/usecases/session/mark_waiting_payment_use_case.dart';
import '../../../application/usecases/session/restore_session_use_case.dart';
import '../../../application/usecases/session/transfer_session_use_case.dart';
import '../../../application/usecases/session/validate_session_use_case.dart';
import '../../../application/mappers/session_mapper.dart';
import '../../../application/validators/session_validator.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/in_memory_session_engine_datasource.dart';
import '../../../data/datasources/session/session_datasource.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../core/network/api_client.dart';
import '../../../data/repositories/session/remote_session_engine_repository.dart';
import '../../../data/repositories/session/session_engine_repository_impl.dart';
import '../../../data/repositories/session/session_repository_impl.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/repositories/session_repository.dart';
import '../../config/app_config.dart';

abstract final class SessionModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<SessionRemoteDataSource>(
      () => const StubSessionRemoteDataSource(),
    );

    sl.registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(remote: sl<SessionRemoteDataSource>()),
    );

    sl.registerLazySingleton(
      () => SessionTimelineRecorder(
        idGenerator: sl<IdGenerator>(),
        clock: sl<Clock>(),
      ),
    );

    final useRemote = sl<AppConfig>().useRemoteBackend;
    if (!useRemote) {
      sl.registerLazySingleton<SessionEngineDataSource>(
        () => InMemorySessionEngineDataSource(
          clock: sl<Clock>(),
          store: sl<OrderingStore>(),
        ),
      );
    }

    sl.registerLazySingleton<SessionEngineRepository>(
      () => useRemote
          ? RemoteSessionEngineRepository(apiClient: sl<ApiClient>())
          : SessionEngineRepositoryImpl(
              dataSource: sl<SessionEngineDataSource>(),
              idGenerator: sl<IdGenerator>(),
              timelineRecorder: sl<SessionTimelineRecorder>(),
              clock: sl<Clock>(),
            ),
    );

    sl.registerLazySingleton(() => const SessionMapper());
    sl.registerLazySingleton(() => const SessionValidator());
    sl.registerLazySingleton(() => const SessionPolicy());

    sl.registerLazySingleton(
      () => CreateSessionUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
      ),
    );

    sl.registerLazySingleton(
      () => JoinSessionUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
      ),
    );

    sl.registerLazySingleton(
      () => CloseSessionUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
      ),
    );

    sl.registerLazySingleton(
      () => MarkWaitingPaymentUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
        idGenerator: sl<IdGenerator>(),
        eventPublisher: sl<DomainEventPublisher>(),
      ),
    );

    sl.registerLazySingleton(
      () => ValidateSessionUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(
      () => RestoreSessionUseCase(
        repository: sl<SessionEngineRepository>(),
      ),
    );

    sl.registerLazySingleton(
      () => TransferSessionUseCase(
        repository: sl<SessionEngineRepository>(),
        policy: sl<SessionPolicy>(),
        clock: sl<Clock>(),
      ),
    );
  }
}
