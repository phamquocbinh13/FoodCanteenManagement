import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';
import '../errors/failures.dart';
import '../logger/app_logger.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Concrete [ApiClient] using `package:http`.
final class HttpApiClient implements ApiClient {
  HttpApiClient({
    required String baseUrl,
    required AppLogger logger,
    AuthTokenProvider? tokenProvider,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl,
        _http = httpClient ?? http.Client(),
        _requestInterceptors = [LoggingInterceptor(logger)],
        _responseInterceptors = [LoggingInterceptor(logger)],
        _errorInterceptors = [RetryLoggingInterceptor(logger)] {
    addRequestInterceptor(
      AuthInterceptor(tokenProvider ?? const NoAuthTokenProvider()),
    );
  }

  final String _baseUrl;
  final http.Client _http;
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

    final uri = Uri.parse('$_baseUrl${processed.path}').replace(
      queryParameters: processed.queryParameters?.map(
        (k, v) => MapEntry(k, '$v'),
      ),
    );

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?processed.headers,
    };

    try {
      final response = await _dispatch(uri, processed, headers);
      dynamic decoded;
      if (response.body.isNotEmpty) {
        decoded = jsonDecode(response.body);
      }

      var apiResponse = ApiResponse<dynamic>(
        statusCode: response.statusCode,
        data: decoded,
        headers: response.headers,
      );
      for (final interceptor in _responseInterceptors) {
        apiResponse = await interceptor.onResponse(apiResponse);
      }

      if (response.statusCode >= 400) {
        throw _mapHttpError(response.statusCode, decoded);
      }

      return ApiResponse<T>(
        statusCode: apiResponse.statusCode,
        data: apiResponse.data as T,
        headers: apiResponse.headers,
      );
    } catch (error, stack) {
      for (final interceptor in _errorInterceptors) {
        await interceptor.onError(error, stack);
      }
      rethrow;
    }
  }

  Future<http.Response> _dispatch(
    Uri uri,
    ApiRequest request,
    Map<String, String> headers,
  ) {
    final body = request.body == null ? null : jsonEncode(request.body);
    return switch (request.method) {
      HttpMethod.get => _http.get(uri, headers: headers),
      HttpMethod.post => _http.post(uri, headers: headers, body: body),
      HttpMethod.put => _http.put(uri, headers: headers, body: body),
      HttpMethod.patch => _http.patch(uri, headers: headers, body: body),
      HttpMethod.delete => _http.delete(uri, headers: headers, body: body),
    };
  }

  Exception _mapHttpError(int statusCode, dynamic body) {
    String? code;
    String message = 'HTTP $statusCode';
    if (body is Map<String, dynamic>) {
      final error = body['error'];
      if (error is Map<String, dynamic>) {
        code = error['code'] as String?;
        message = (error['message'] as String?) ?? message;
      } else if (body['message'] is String) {
        message = body['message'] as String;
      }
    }

    return switch (statusCode) {
      401 => UnauthorizedException(message, code: code ?? 'UNAUTHORIZED'),
      403 => ForbiddenException(message, code: code ?? 'FORBIDDEN'),
      404 => NotFoundException(message, code: code ?? 'NOT_FOUND'),
      409 => ConflictException(message, code: code ?? 'CONFLICT'),
      422 => ValidationException(message, code: code ?? 'VALIDATION'),
      _ => NetworkException(message, code: code ?? 'HTTP_$statusCode'),
    };
  }
}

/// Maps network exceptions into domain [Failure]s for repository boundaries.
Failure failureFromException(Object error) {
  if (error is Failure) return error;
  if (error is AppException) {
    return switch (error) {
      UnauthorizedException(:final message, :final code) =>
        UnauthorizedFailure(message, code: code),
      ForbiddenException(:final message, :final code) =>
        UnauthorizedFailure(message, code: code),
      NotFoundException(:final message, :final code) =>
        NotFoundFailure(message, code: code),
      ValidationException(:final message, :final code) =>
        ValidationFailure(message, code: code),
      ConflictException(:final message, :final code) =>
        ValidationFailure(message, code: code),
      NetworkException(:final message, :final code) =>
        NetworkFailure(message, code: code),
      _ => UnknownFailure(error.toString()),
    };
  }
  return UnknownFailure(error.toString());
}
