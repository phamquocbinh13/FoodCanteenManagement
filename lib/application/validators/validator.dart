import '../../core/errors/failures.dart';
import '../../core/result/result.dart';

/// Validates input before it reaches domain services or repositories.
abstract interface class Validator<T> {
  Result<void> validate(T input);
}

/// Combines multiple validators; returns first failure encountered.
final class CompositeValidator<T> implements Validator<T> {
  CompositeValidator(this._validators);

  final List<Validator<T>> _validators;

  @override
  Result<void> validate(T input) {
    for (final validator in _validators) {
      final result = validator.validate(input);
      if (result is Err<void>) return result;
    }
    return const Success(null);
  }
}

/// Validates that a required string field is non-empty.
final class RequiredStringValidator implements Validator<String> {
  const RequiredStringValidator({required this.fieldName});

  final String fieldName;

  @override
  Result<void> validate(String input) {
    if (input.trim().isEmpty) {
      return Err(ValidationFailure('$fieldName is required', code: fieldName));
    }
    return const Success(null);
  }
}

/// Convenience to wrap validation failure as [Err].
Result<void> validationError(String message, {String? code}) {
  return Err(ValidationFailure(message, code: code));
}
