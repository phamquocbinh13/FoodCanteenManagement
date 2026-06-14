import 'package:get_it/get_it.dart';

import '../../../application/mappers/user_mapper.dart';
import '../../../application/usecases/auth/login_use_case.dart';
import '../../../application/validators/user_validator.dart';
import '../../../data/datasources/user/user_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/repositories/restaurant_repository.dart';

abstract final class AuthModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<UserRemoteDataSource>(
      () => const StubUserRemoteDataSource(),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remote: sl<UserRemoteDataSource>()),
    );

    sl.registerLazySingleton(() => const UserMapper());
    sl.registerLazySingleton(() => const UserValidator());

    sl.registerLazySingleton(
      () => LoginUseCase(userRepository: sl<UserRepository>()),
    );
  }
}
