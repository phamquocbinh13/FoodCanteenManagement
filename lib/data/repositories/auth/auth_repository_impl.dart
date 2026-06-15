import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/entities/authenticated_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../application/auth/auth_constants.dart';
import '../../datasources/auth/auth_datasource.dart';

/// Auth repository orchestrating remote login and local session persistence.
final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required Clock clock,
  })  : _remote = remote,
        _local = local,
        _clock = clock;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final Clock _clock;

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    final loginResult = await _remote.login(
      username: username,
      password: password,
    );

    return switch (loginResult) {
      Err<AuthSession>(:final failure) => Err(failure),
      Success<AuthSession>(:final value) => _persistSession(value),
    };
  }

  Future<Result<AuthSession>> _persistSession(AuthSession session) async {
    if (!session.user.active) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.userInactive,
          code: AuthErrorCodes.userInactive,
        ),
      );
    }

    final saveResult = await _local.saveSession(session);
    if (saveResult is Err<void>) return Err(saveResult.failure);
    return Success(session);
  }

  @override
  Future<Result<void>> logout() => _local.clearSession();

  @override
  Future<Result<AuthSession>> refreshToken() async {
    final stored = await _local.readSession();
    if (stored is Err<AuthSession?>) return Err(stored.failure);

    final current = stored.valueOrNull;
    if (current == null) {
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.sessionExpired,
          code: AuthErrorCodes.sessionExpired,
        ),
      );
    }

    final refreshResult = await _remote.refreshToken(
      refreshToken: current.refreshToken,
    );

    return switch (refreshResult) {
      Err<AuthSession>(:final failure) => Err(failure),
      Success<AuthSession>(:final value) => _persistSession(value),
    };
  }

  @override
  Future<Result<AuthenticatedUser?>> getCurrentUser() async {
    final sessionResult = await getStoredSession();
    return switch (sessionResult) {
      Err<AuthSession?>(:final failure) => Err(failure),
      Success<AuthSession?>(:final value) => Success(value?.user),
    };
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    final validResult = await _local.hasValidSession(now: _clock.now());
    if (validResult is Err<bool>) return validResult;

    if (validResult.valueOrNull != true) {
      return const Success(false);
    }

    final sessionResult = await _local.readSession();
    if (sessionResult is Err<AuthSession?>) return Err(sessionResult.failure);

    final session = sessionResult.valueOrNull;
    if (session == null) return const Success(false);

    if (_clock.now().isAfter(session.expiresAt)) {
      await _local.clearSession();
      return const Success(false);
    }

    return const Success(true);
  }

  @override
  Future<Result<AuthSession?>> getStoredSession() async {
    final sessionResult = await _local.readSession();
    if (sessionResult is Err<AuthSession?>) return sessionResult;

    final session = sessionResult.valueOrNull;
    if (session == null) return const Success(null);

    if (_clock.now().isAfter(session.expiresAt)) {
      await _local.clearSession();
      return const Err(
        UnauthorizedFailure(
          AuthErrorMessages.sessionExpired,
          code: AuthErrorCodes.sessionExpired,
        ),
      );
    }

    return Success(session);
  }
}
