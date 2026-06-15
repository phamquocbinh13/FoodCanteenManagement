import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../use_case.dart';

final class RefreshTokenUseCase implements UseCase<AuthSession, NoParams> {
  RefreshTokenUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<AuthSession>> call(NoParams params) {
    return _authRepository.refreshToken();
  }
}
