import '../../core/result/result.dart';
import '../entities/auth_session.dart';
import '../entities/authenticated_user.dart';

/// Authentication persistence and token contract.
abstract interface class AuthRepository {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<AuthSession>> refreshToken();

  Future<Result<AuthenticatedUser?>> getCurrentUser();

  Future<Result<bool>> isAuthenticated();

  Future<Result<AuthSession?>> getStoredSession();
}
