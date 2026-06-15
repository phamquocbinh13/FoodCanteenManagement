import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../use_case.dart';

/// Restores persisted session on app launch (splash).
final class CheckAuthenticationUseCase
    implements UseCase<AuthSession?, NoParams> {
  CheckAuthenticationUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<AuthSession?>> call(NoParams params) async {
    final isAuthResult = await _authRepository.isAuthenticated();
    if (isAuthResult is Err<bool>) return Err(isAuthResult.failure);
    if (isAuthResult.valueOrNull != true) return const Success(null);

    return _authRepository.getStoredSession();
  }
}
