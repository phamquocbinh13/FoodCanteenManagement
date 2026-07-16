import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../use_case.dart';

import '../../../core/network/session_token_headers.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';

final class CheckPaymentStatusUseCase
    implements UseCase<String, void> {
  CheckPaymentStatusUseCase(this._api, this._local);

  final ApiClient _api;
  final CustomerSessionLocalDataSource _local;

  @override
  Future<Result<String>> call(void params) async {
    try {
      final headers = await customerSessionHeaders(_local);
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me/payments/status',
          method: HttpMethod.get,
          headers: headers,
        ),
      );
      final status = response.data['status'] as String;
      return Success(status);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
