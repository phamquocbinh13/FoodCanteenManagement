/// Infrastructure and application-layer exceptions.
///
/// Domain rule violations use [DomainException] in `lib/domain/`.
/// This hierarchy covers network, storage, and unexpected errors.
sealed class AppException implements Exception {
  const AppException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => 'AppException($code): $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.cause});
}

final class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.cause});
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.code, super.cause});
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.cause});
}

final class ForbiddenException extends AppException {
  const ForbiddenException(super.message, {super.code, super.cause});
}

final class ConflictException extends AppException {
  const ConflictException(super.message, {super.code, super.cause});
}

final class UnknownAppException extends AppException {
  const UnknownAppException(super.message, {super.code, super.cause});
}
