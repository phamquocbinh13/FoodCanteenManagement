import '../../../core/result/result.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../use_case.dart';

final class LogoutUseCase implements UseCase<void, NoParams> {
  LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(NoParams params) => _authRepository.logout();
}
