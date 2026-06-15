import 'package:get_it/get_it.dart';

import '../../../application/usecases/auth/auth_usecases.dart';
import '../../../application/validators/user_validator.dart';
import '../../../core/permissions/permission_service.dart';
import '../../../data/datasources/auth/auth_datasource.dart';
import '../../../data/datasources/auth/auth_local_datasource.dart';
import '../../../data/datasources/auth/mock_auth_remote_datasource.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/storage/local_storage.dart';

abstract final class AuthModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<RoleBasedPermissionService>(
      RoleBasedPermissionService.new,
    );

    sl.registerLazySingleton<PermissionService>(
      () => sl<RoleBasedPermissionService>(),
    );

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => MockAuthRemoteDataSource(
        clock: sl<Clock>(),
        idGenerator: sl<IdGenerator>(),
      ),
    );

    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl<AuthRemoteDataSource>(),
        local: sl<AuthLocalDataSource>(),
        clock: sl<Clock>(),
      ),
    );

    sl.registerLazySingleton(() => const UserValidator());

    sl.registerLazySingleton(
      () => LoginUseCase(
        authRepository: sl<AuthRepository>(),
        userValidator: sl<UserValidator>(),
      ),
    );

    sl.registerLazySingleton(
      () => LogoutUseCase(authRepository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton(
      () => GetCurrentUserUseCase(authRepository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton(
      () => RefreshTokenUseCase(authRepository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton(
      () => CheckAuthenticationUseCase(authRepository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton(
      () => AuthController(
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        checkAuthenticationUseCase: sl<CheckAuthenticationUseCase>(),
        permissionService: sl<RoleBasedPermissionService>(),
      ),
    );
  }
}
