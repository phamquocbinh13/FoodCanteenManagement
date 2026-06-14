import '../../logger/app_logger.dart';
import '../api_client.dart';

/// Logs outgoing requests and incoming responses.
final class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  Future<ApiRequest> onRequest(ApiRequest request) async {
    _logger.debug(
      '→ ${request.method.name.toUpperCase()} ${request.path}',
      data: request.queryParameters,
    );
    return request;
  }

  @override
  Future<ApiResponse<dynamic>> onResponse(ApiResponse<dynamic> response) async {
    _logger.debug('← ${response.statusCode}', data: response.data);
    return response;
  }
}
