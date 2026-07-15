import 'package:food_canteen_management/application/auth/auth_constants.dart';
import 'package:food_canteen_management/core/clock/clock.dart';
import 'package:food_canteen_management/core/errors/failures.dart';
import 'package:food_canteen_management/core/id/id_generator.dart';
import 'package:food_canteen_management/core/permissions/permission_service.dart';
import 'package:food_canteen_management/core/result/result.dart';
import 'package:food_canteen_management/domain/entities/auth_session.dart';
import 'package:food_canteen_management/domain/entities/authenticated_user.dart';
import 'package:food_canteen_management/domain/enums/domain_enums.dart';
import 'package:food_canteen_management/data/datasources/auth/auth_datasource.dart';

/// Demo mock credentials. Logic lives here only — never in UI.
final class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  MockAuthRemoteDataSource({
    required Clock clock,
    required IdGenerator idGenerator,
  })  : _clock = clock,
        _idGenerator = idGenerator;

  final Clock _clock;
  final IdGenerator _idGenerator;

  static const _demoUsers = <String, _DemoCredential>{
    'admin': _DemoCredential(
      password: 'admin123',
      role: RoleKey.admin,
      fullName: 'System Admin',
    ),
    'manager': _DemoCredential(
      password: 'manager123',
      role: RoleKey.manager,
      fullName: 'Floor Manager',
    ),
    'cashier': _DemoCredential(
      password: 'cashier123',
      role: RoleKey.cashier,
      fullName: 'Front Cashier',
    ),
    'kitchen': _DemoCredential(
      password: 'kitchen123',
      role: RoleKey.kitchen,
      fullName: 'Kitchen Staff',
    ),
    'shipper': _DemoCredential(
      password: 'shipper123',
      role: RoleKey.shipper,
      fullName: 'Delivery Shipper',
    ),
  };

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final normalized = username.trim().toLowerCase();
    final credential = _demoUsers[normalized];

    if (credential == null) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.invalidUsername,
          code: AuthErrorCodes.invalidUsername,
        ),
      );
    }

    if (password != credential.password) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.invalidPassword,
          code: AuthErrorCodes.invalidPassword,
        ),
      );
    }

    return Success(_buildSession(normalized, credential));
  }

  @override
  Future<Result<AuthSession>> refreshToken({
    required String refreshToken,
  }) async {
    if (!refreshToken.startsWith('refresh_')) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.sessionExpired,
          code: AuthErrorCodes.sessionExpired,
        ),
      );
    }

    final username = refreshToken.replaceFirst('refresh_', '');
    final credential = _demoUsers[username];
    if (credential == null) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.sessionExpired,
          code: AuthErrorCodes.sessionExpired,
        ),
      );
    }

    return Success(_buildSession(username, credential));
  }

  AuthSession _buildSession(String username, _DemoCredential credential) {
    final now = _clock.now();
    final permissions = RolePermissions.defaults[credential.role] ?? {};
    final user = AuthenticatedUser(
      id: 'user_$username',
      username: username,
      fullName: credential.fullName,
      role: credential.role,
      permissions: permissions.map((p) => p.name).toList(),
      active: true,
      createdAt: now,
    );

    return AuthSession(
      user: user,
      accessToken: 'access_${_idGenerator.nextId()}',
      refreshToken: 'refresh_$username',
      expiresAt: now.add(const Duration(hours: 8)),
    );
  }
}

final class _DemoCredential {
  const _DemoCredential({
    required this.password,
    required this.role,
    required this.fullName,
  });

  final String password;
  final RoleKey role;
  final String fullName;
}
