import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../datasource.dart';

abstract interface class MenuRemoteDataSource implements RemoteDataSource {}

abstract interface class MenuLocalDataSource implements LocalDataSource {}

abstract interface class MenuMemoryDataSource implements MemoryDataSource {}

final class StubMenuRemoteDataSource implements MenuRemoteDataSource {
  const StubMenuRemoteDataSource();

  @override
  Future<Result<void>> ping() async {
    return const Err(UnknownFailure('Menu remote datasource not configured'));
  }
}
