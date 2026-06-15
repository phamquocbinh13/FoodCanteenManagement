import '../../core/result/result.dart';
import 'validator.dart';

final class UserValidator implements Validator<UserValidationInput> {
  const UserValidator();

  @override
  Result<void> validate(UserValidationInput input) {
    if (input.username.trim().isEmpty) {
      return validationError('Username is required', code: 'username');
    }
    if (input.password.isEmpty) {
      return validationError('Password is required', code: 'password');
    }
    if (input.password.length < 6) {
      return validationError(
        'Password must be at least 6 characters',
        code: 'password',
      );
    }
    return const Success(null);
  }
}

final class UserValidationInput {
  const UserValidationInput({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;
}
