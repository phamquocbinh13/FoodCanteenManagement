import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';

/// Remote authentication contract (API or mock).
abstract interface class AuthRemoteDataSource {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<AuthSession>> refreshToken({required String refreshToken});
}

/// Local authentication persistence contract.
abstract interface class AuthLocalDataSource {
  Future<Result<void>> saveSession(AuthSession session);

  Future<Result<AuthSession?>> readSession();

  Future<Result<void>> clearSession();

  Future<Result<bool>> hasValidSession({required DateTime now});
}
