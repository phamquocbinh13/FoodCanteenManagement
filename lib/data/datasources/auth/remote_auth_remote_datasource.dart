import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/json_key_codec.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/auth_session.dart';
import 'auth_datasource.dart';

/// NestJS `/auth` remote adapter.
final class RemoteAuthRemoteDataSource implements AuthRemoteDataSource {
  RemoteAuthRemoteDataSource({required ApiClient apiClient})
      : _api = apiClient;

  final ApiClient _api;

  AuthSession _parse(Map<String, dynamic> json) {
    return AuthSession.fromJson(camelCaseKeysToSnake(json));
  }

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/auth/login',
          method: HttpMethod.post,
          requiresAuth: false,
          body: {'username': username, 'password': password},
        ),
      );
      return Success(_parse(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<AuthSession>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/auth/refresh',
          method: HttpMethod.post,
          requiresAuth: false,
          body: {'refreshToken': refreshToken},
        ),
      );
      return Success(_parse(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
