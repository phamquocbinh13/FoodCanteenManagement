import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../use_case.dart';

import '../../../core/network/session_token_headers.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';

final class CreateVnpayIntentUseCase
    implements UseCase<String, void> {
  CreateVnpayIntentUseCase(this._api, this._local);

  final ApiClient _api;
  final CustomerSessionLocalDataSource _local;

  @override
  Future<Result<String>> call(void params) async {
    try {
      final headers = await customerSessionHeaders(_local);
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me/payments/vnpay/create',
          method: HttpMethod.post,
          headers: headers,
        ),
      );
      final url = response.data['checkoutUrl'] as String;
      return Success(url);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
