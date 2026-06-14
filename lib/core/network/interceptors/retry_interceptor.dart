import '../../logger/app_logger.dart';
import '../api_client.dart';

/// Configuration for automatic request retries.
class RetryConfig {
  const RetryConfig({
    this.maxAttempts = 3,
    this.retryableStatusCodes = const {408, 429, 500, 502, 503, 504},
  });

  final int maxAttempts;
  final Set<int> retryableStatusCodes;
}

/// Retry policy hook. Actual retry loop lives in the concrete [ApiClient].
abstract interface class RetryPolicy {
  bool shouldRetry(ApiRequest request, int attempt, Object error);
  Duration delayForAttempt(int attempt);
}

final class ExponentialBackoffRetryPolicy implements RetryPolicy {
  ExponentialBackoffRetryPolicy({this.config = const RetryConfig()});

  final RetryConfig config;

  @override
  bool shouldRetry(ApiRequest request, int attempt, Object error) {
    return attempt < config.maxAttempts;
  }

  @override
  Duration delayForAttempt(int attempt) {
    return Duration(milliseconds: 300 * (1 << attempt));
  }
}

final class RetryLoggingInterceptor implements ErrorInterceptor {
  RetryLoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  Future<void> onError(Object error, StackTrace stackTrace) async {
    _logger.warning('Request failed, retry hook invoked', data: error);
  }
}
