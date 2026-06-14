import 'package:get_it/get_it.dart';

import '../../../application/mappers/session_mapper.dart';
import '../../../application/policies/session_policy.dart';
import '../../../application/usecases/session/close_session_use_case.dart';
import '../../../application/usecases/session/create_session_use_case.dart';
import '../../../application/usecases/session/join_session_use_case.dart';
import '../../../application/validators/session_validator.dart';
import '../../../data/datasources/session/session_datasource.dart';
import '../../../data/repositories/session/session_repository_impl.dart';
import '../../../domain/repositories/session_repository.dart';

abstract final class SessionModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<SessionRemoteDataSource>(
      () => const StubSessionRemoteDataSource(),
    );

    sl.registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(remote: sl<SessionRemoteDataSource>()),
    );

    sl.registerLazySingleton(() => const SessionMapper());
    sl.registerLazySingleton(() => const SessionValidator());
    sl.registerLazySingleton(() => const SessionPolicy());

    sl.registerLazySingleton(
      () => CreateSessionUseCase(sessionRepository: sl<SessionRepository>()),
    );

    sl.registerLazySingleton(
      () => JoinSessionUseCase(sessionRepository: sl<SessionRepository>()),
    );

    sl.registerLazySingleton(
      () => CloseSessionUseCase(
        sessionRepository: sl<SessionRepository>(),
        paymentRepository: sl(),
      ),
    );
  }
}
