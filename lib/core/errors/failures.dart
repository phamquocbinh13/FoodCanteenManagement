import 'app_exception.dart';

/// Typed failure for repository and use-case results (Either-style).
///
/// Domain failures from business rules are mapped separately from
/// infrastructure failures defined here.
sealed class Failure {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}

/// Maps [AppException] instances to [Failure] for presentation layer.
Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NetworkException() => NetworkFailure(exception.message, code: exception.code),
    ValidationException() => ValidationFailure(exception.message, code: exception.code),
    StorageException() => StorageFailure(exception.message, code: exception.code),
    UnauthorizedException() => UnauthorizedFailure(exception.message, code: exception.code),
    NotFoundException() => NotFoundFailure(exception.message, code: exception.code),
    _ => UnknownFailure(exception.message, code: exception.code),
  };
}
