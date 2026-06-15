import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../validators/user_validator.dart';
import '../use_case.dart';

/// Authenticates staff credentials against the auth repository.
final class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  LoginUseCase({
    required AuthRepository authRepository,
    required UserValidator userValidator,
  })  : _authRepository = authRepository,
        _userValidator = userValidator;

  final AuthRepository _authRepository;
  final UserValidator _userValidator;

  @override
  Future<Result<AuthSession>> call(LoginParams params) async {
    final validation = _userValidator.validate(
      UserValidationInput(
        username: params.username,
        password: params.password,
      ),
    );
    if (validation is Err<void>) return Err(validation.failure);

    return _authRepository.login(
      username: params.username.trim(),
      password: params.password,
    );
  }
}

final class LoginParams {
  const LoginParams({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}
