import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../datasource.dart';

/// Remote session API contract (Sprint 3+).
abstract interface class SessionRemoteDataSource implements RemoteDataSource {}

/// Local session cache contract (Sprint 3+).
abstract interface class SessionLocalDataSource implements LocalDataSource {}

/// In-memory session store for tests and offline drafts.
abstract interface class SessionMemoryDataSource implements MemoryDataSource {}

/// Stub remote datasource returning not-configured failure.
final class StubSessionRemoteDataSource implements SessionRemoteDataSource {
  const StubSessionRemoteDataSource();

  @override
  Future<Result<void>> ping() async {
    return const Err(UnknownFailure('Session remote datasource not configured'));
  }
}
