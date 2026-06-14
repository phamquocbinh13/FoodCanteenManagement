/// HTTP method verbs supported by [ApiClient].
enum HttpMethod { get, post, put, patch, delete }

/// Request configuration for [ApiClient].
class ApiRequest {
  const ApiRequest({
    required this.path,
    this.method = HttpMethod.get,
    this.headers,
    this.queryParameters,
    this.body,
    this.requiresAuth = true,
  });

  final String path;
  final HttpMethod method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParameters;
  final Object? body;
  final bool requiresAuth;
}

/// Response wrapper from [ApiClient].
class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    required this.data,
    this.headers,
  });

  final int statusCode;
  final T data;
  final Map<String, String>? headers;
}

/// Interceptor invoked before a request is sent.
abstract interface class RequestInterceptor {
  Future<ApiRequest> onRequest(ApiRequest request);
}

/// Interceptor invoked after a response is received.
abstract interface class ResponseInterceptor {
  Future<ApiResponse<dynamic>> onResponse(ApiResponse<dynamic> response);
}

/// Interceptor invoked when a request fails.
abstract interface class ErrorInterceptor {
  Future<void> onError(Object error, StackTrace stackTrace);
}

/// Transport-agnostic HTTP client contract.
///
/// Concrete implementation (Dio, http package) will be added in a future sprint.
abstract interface class ApiClient {
  Future<ApiResponse<T>> send<T>(ApiRequest request);

  void addRequestInterceptor(RequestInterceptor interceptor);
  void addResponseInterceptor(ResponseInterceptor interceptor);
  void addErrorInterceptor(ErrorInterceptor interceptor);
}
