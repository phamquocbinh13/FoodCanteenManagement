import '../errors/app_exception.dart';
import '../logger/app_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'api_client.dart';

/// Stub [ApiClient] that wires interceptors but performs no real HTTP calls.
///
/// Replace with Dio/http implementation when API sprint begins.
final class StubApiClient implements ApiClient {
  StubApiClient({required AppLogger logger})
      : _logger = logger,
        _requestInterceptors = [LoggingInterceptor(logger)],
        _responseInterceptors = [LoggingInterceptor(logger)],
        _errorInterceptors = [RetryLoggingInterceptor(logger)] {
    addRequestInterceptor(AuthInterceptor(const NoAuthTokenProvider()));
  }

  final AppLogger _logger;
  final List<RequestInterceptor> _requestInterceptors;
  final List<ResponseInterceptor> _responseInterceptors;
  final List<ErrorInterceptor> _errorInterceptors;

  @override
  void addRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  @override
  void addResponseInterceptor(ResponseInterceptor interceptor) {
    _responseInterceptors.add(interceptor);
  }

  @override
  void addErrorInterceptor(ErrorInterceptor interceptor) {
    _errorInterceptors.add(interceptor);
  }

  @override
  Future<ApiResponse<T>> send<T>(ApiRequest request) async {
    var processed = request;
    for (final interceptor in _requestInterceptors) {
      processed = await interceptor.onRequest(processed);
    }

    _logger.warning(
      'StubApiClient: no transport configured for ${processed.path}',
    );

    throw const NetworkException(
      'API client not configured',
      code: 'API_NOT_CONFIGURED',
    );
  }
}
