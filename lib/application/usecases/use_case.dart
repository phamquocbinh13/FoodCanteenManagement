import '../../core/result/result.dart';

/// Base contract for application-layer orchestrators.
///
/// UI → Provider → UseCase → Repository → Datasource
abstract interface class UseCase<TResult, TParams> {
  Future<Result<TResult>> call(TParams params);
}

/// Marker for use cases that require no input parameters.
final class NoParams {
  const NoParams();
}

/// Synchronous use case variant for pure validation/policy checks.
abstract interface class SyncUseCase<TResult, TParams> {
  Result<TResult> call(TParams params);
}
