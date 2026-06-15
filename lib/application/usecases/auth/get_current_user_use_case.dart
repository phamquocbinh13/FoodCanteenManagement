import '../../../core/result/result.dart';
import '../../../domain/entities/authenticated_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../use_case.dart';

final class GetCurrentUserUseCase
    implements UseCase<AuthenticatedUser?, NoParams> {
  GetCurrentUserUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<AuthenticatedUser?>> call(NoParams params) {
    return _authRepository.getCurrentUser();
  }
}
