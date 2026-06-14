import '../../core/errors/failures.dart';
import '../../core/result/result.dart';

/// Helpers for repository implementations migrating to [Result].
///
/// Existing domain repository interfaces remain unchanged for backward
/// compatibility. Implementations should use these helpers internally and
/// map to [Result] at the use-case boundary.
abstract final class RepositoryResult {
  static Future<Result<T>> fromFuture<T>(Future<T> future) => Result.guard(
        () => future,
      );

  static Result<T> fromSync<T>(T Function() action) => Result.guardSync(action);

  static Err<T> notConfigured<T>(String repository, String method) {
    return Err(
      UnknownFailure(
        '$repository.$method is not configured',
        code: 'NOT_CONFIGURED',
      ),
    );
  }
}
