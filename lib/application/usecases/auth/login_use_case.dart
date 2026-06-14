import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../use_case.dart';

/// Authenticates staff credentials. Implementation deferred to Sprint 2.
final class LoginUseCase implements UseCase<Object?, LoginParams> {
  LoginUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  // ignore: unused_field
  final UserRepository _userRepository;

  @override
  Future<Result<Object?>> call(LoginParams params) async {
    return const Err(UnknownFailure('LoginUseCase not implemented'));
  }
}

final class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
    required this.restaurantId,
  });

  final String email;
  final String password;
  final String restaurantId;
}
