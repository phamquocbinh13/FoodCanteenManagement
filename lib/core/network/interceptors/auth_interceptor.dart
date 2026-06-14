import '../api_client.dart';

/// Hook for attaching auth tokens to outgoing requests.
///
/// Token resolution is deferred to Sprint 2 (Authentication).
abstract interface class AuthTokenProvider {
  Future<String?> getAccessToken();
}

final class AuthInterceptor implements RequestInterceptor {
  AuthInterceptor(this._tokenProvider);

  final AuthTokenProvider _tokenProvider;

  @override
  Future<ApiRequest> onRequest(ApiRequest request) async {
    if (!request.requiresAuth) return request;

    final token = await _tokenProvider.getAccessToken();
    if (token == null) return request;

    return ApiRequest(
      path: request.path,
      method: request.method,
      headers: {
        ...?request.headers,
        'Authorization': 'Bearer $token',
      },
      queryParameters: request.queryParameters,
      body: request.body,
      requiresAuth: request.requiresAuth,
    );
  }
}

/// Stub token provider until auth is implemented.
final class NoAuthTokenProvider implements AuthTokenProvider {
  const NoAuthTokenProvider();

  @override
  Future<String?> getAccessToken() async => null;
}
