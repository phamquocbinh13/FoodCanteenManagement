import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../datasource.dart';

abstract interface class PaymentRemoteDataSource implements RemoteDataSource {}

abstract interface class PaymentLocalDataSource implements LocalDataSource {}

final class StubPaymentRemoteDataSource implements PaymentRemoteDataSource {
  const StubPaymentRemoteDataSource();

  @override
  Future<Result<void>> ping() async {
    return const Err(UnknownFailure('Payment remote datasource not configured'));
  }
}
