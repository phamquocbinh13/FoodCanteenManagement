import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../datasource.dart';

abstract interface class UserRemoteDataSource implements RemoteDataSource {}

abstract interface class UserLocalDataSource implements LocalDataSource {}

final class StubUserRemoteDataSource implements UserRemoteDataSource {
  const StubUserRemoteDataSource();

  @override
  Future<Result<void>> ping() async {
    return const Err(UnknownFailure('User remote datasource not configured'));
  }
}
