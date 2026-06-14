import '../../core/result/result.dart';
import 'validator.dart';

final class UserValidator implements Validator<UserValidationInput> {
  const UserValidator();

  @override
  Result<void> validate(UserValidationInput input) {
    if (input.email.trim().isEmpty) {
      return validationError('Email is required', code: 'email');
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
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
