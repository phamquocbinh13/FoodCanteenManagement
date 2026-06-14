import '../errors/failures.dart';

/// Functional result type for repository and use-case boundaries.
///
/// Prefer returning [Result] over throwing exceptions from repositories.
/// Integrates with the existing [Failure] hierarchy in `core/errors/`.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Err<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Err<T>(:final failure) => failure,
      };

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Err<T>(:final failure) => onFailure(failure),
    };
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Success(transform(value)),
      Err<T>(:final failure) => Err(failure),
    };
  }

  /// Executes [action] and wraps success or maps exceptions to [Err].
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Failure catch (failure) {
      return Err(failure);
    } catch (error) {
      return Err(UnknownFailure(error.toString()));
    }
  }

  /// Synchronous variant of [guard].
  static Result<T> guardSync<T>(T Function() action) {
    try {
      return Success(action());
    } on Failure catch (failure) {
      return Err(failure);
    } catch (error) {
      return Err(UnknownFailure(error.toString()));
    }
  }
}

/// Successful outcome carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Failed outcome carrying a typed [Failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
