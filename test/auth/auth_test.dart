import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/application/auth/role_resolver.dart';
import 'package:food_canteen_management/application/usecases/auth/login_use_case.dart';
import 'package:food_canteen_management/application/usecases/auth/logout_use_case.dart';
import 'package:food_canteen_management/application/usecases/use_case.dart';
import 'package:food_canteen_management/application/validators/user_validator.dart';
import 'package:food_canteen_management/app/router/route_paths.dart';
import 'package:food_canteen_management/core/clock/fake_clock.dart';
import 'package:food_canteen_management/core/id/id_generator.dart';
import 'package:food_canteen_management/core/permissions/permission_service.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/core/storage/local_storage.dart';
import 'package:food_canteen_management/data/datasources/auth/auth_local_datasource.dart';
import 'package:food_canteen_management/data/datasources/auth/mock_auth_remote_datasource.dart';
import 'package:food_canteen_management/data/repositories/auth/auth_repository_impl.dart';
import 'package:food_canteen_management/domain/entities/auth_session.dart';
import 'package:food_canteen_management/domain/entities/authenticated_user.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/domain/repositories/auth_repository.dart';

void main() {
  group('RoleResolver', () {
    test('maps roles to home routes', () {
      expect(RoleResolver.homeRouteFor(RoleKey.admin), RoutePaths.admin);
      expect(RoleResolver.homeRouteFor(RoleKey.manager), RoutePaths.admin);
      expect(RoleResolver.homeRouteFor(RoleKey.cashier), RoutePaths.cashier);
      expect(RoleResolver.homeRouteFor(RoleKey.kitchen), RoutePaths.kitchen);
      expect(RoleResolver.homeRouteFor(RoleKey.shipper), RoutePaths.shipper);
    });

    test('cashier cannot access admin route', () {
      expect(
        RoleResolver.canAccessRoute(RoleKey.cashier, RoutePaths.admin),
        isFalse,
      );
    });

    test('admin can access staff routes', () {
      expect(
        RoleResolver.canAccessRoute(RoleKey.admin, RoutePaths.kitchen),
        isTrue,
      );
    });
  });

  group('MockAuthRemoteDataSource', () {
    late FakeClock clock;
    late MockAuthRemoteDataSource datasource;

    setUp(() {
      clock = FakeClock(DateTime.utc(2026, 6, 15, 10));
      datasource = MockAuthRemoteDataSource(
        clock: clock,
        idGenerator: FakeIdGenerator(prefix: 'id'),
      );
    });

    test('accepts valid admin credentials', () async {
      final result = await datasource.login(
        username: 'admin',
        password: 'admin123',
      );
      expect(result, isA<Success<AuthSession>>());
      final session = (result as Success<AuthSession>).value;
      expect(session.user.role, RoleKey.admin);
      expect(session.expiresAt.isAfter(clock.now()), isTrue);
    });

    test('rejects invalid username', () async {
      final result = await datasource.login(
        username: 'unknown',
        password: 'admin123',
      );
      expect(result, isA<Err<AuthSession>>());
    });

    test('rejects invalid password', () async {
      final result = await datasource.login(
        username: 'admin',
        password: 'wrong',
      );
      expect(result, isA<Err<AuthSession>>());
    });
  });

  group('Auth persistence', () {
    test('login persists and restores session', () async {
      final clock = FakeClock(DateTime.utc(2026, 6, 15, 10));
      final storage = InMemoryLocalStorage();
      await storage.init();

      final repository = AuthRepositoryImpl(
        remote: MockAuthRemoteDataSource(
          clock: clock,
          idGenerator: FakeIdGenerator(prefix: 'id'),
        ),
        local: AuthLocalDataSourceImpl(storage),
        clock: clock,
      );

      final loginResult = await repository.login(
        username: 'cashier',
        password: 'cashier123',
      );
      expect(loginResult, isA<Success<AuthSession>>());

      final isAuth = await repository.isAuthenticated();
      expect((isAuth as Success<bool>).value, isTrue);

      final userResult = await repository.getCurrentUser();
      expect((userResult as Success<AuthenticatedUser?>).value?.username,
          'cashier');

      await repository.logout();
      final afterLogout = await repository.isAuthenticated();
      expect((afterLogout as Success<bool>).value, isFalse);
    });
  });

  group('LoginUseCase', () {
    test('returns validation failure for empty username', () async {
      final useCase = LoginUseCase(
        authRepository: _FailingRepository(),
        userValidator: const UserValidator(),
      );

      final result = await useCase(
        const LoginParams(username: '', password: 'cashier123'),
      );
      expect(result, isA<Err<AuthSession>>());
    });
  });

  group('LogoutUseCase', () {
    test('delegates to repository', () async {
      var called = false;
      final useCase = LogoutUseCase(
        authRepository: _LogoutSpy(onLogout: () => called = true),
      );

      await useCase(const NoParams());
      expect(called, isTrue);
    });
  });

  group('RoleBasedPermissionService', () {
    test('grants kitchen permissions after role update', () {
      final service = RoleBasedPermissionService();
      service.updateFromRole(RoleKey.kitchen);
      expect(service.hasPermission(AppPermission.viewKitchenQueue), isTrue);
      expect(service.hasPermission(AppPermission.manageStaff), isFalse);
    });
  });
}

class _FailingRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() async => throw UnimplementedError();

  @override
  Future<Result<AuthSession>> refreshToken() async =>
      throw UnimplementedError();

  @override
  Future<Result<AuthenticatedUser?>> getCurrentUser() async =>
      throw UnimplementedError();

  @override
  Future<Result<bool>> isAuthenticated() async => throw UnimplementedError();

  @override
  Future<Result<AuthSession?>> getStoredSession() async =>
      throw UnimplementedError();
}

class _LogoutSpy implements AuthRepository {
  _LogoutSpy({required this.onLogout});

  final void Function() onLogout;

  @override
  Future<Result<void>> logout() async {
    onLogout();
    return const Success(null);
  }

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Result<AuthSession>> refreshToken() async =>
      throw UnimplementedError();

  @override
  Future<Result<AuthenticatedUser?>> getCurrentUser() async =>
      throw UnimplementedError();

  @override
  Future<Result<bool>> isAuthenticated() async => throw UnimplementedError();

  @override
  Future<Result<AuthSession?>> getStoredSession() async =>
      throw UnimplementedError();
}
