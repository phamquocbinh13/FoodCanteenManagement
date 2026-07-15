import 'package:food_canteen_management/core/logger/app_logger.dart';
import 'package:food_canteen_management/core/network/api_client.dart';
import 'package:food_canteen_management/core/storage/local_storage.dart';

import '../fakes/fake_clock.dart';
import '../fakes/fake_id_generator.dart';

export '../fakes/fake_clock.dart';
export '../fakes/fake_id_generator.dart';

/// Captures log output for assertions in tests.
final class FakeLogger implements AppLogger {
  final List<String> logs = [];

  @override
  void debug(String message, {Object? data, StackTrace? stackTrace}) {
    logs.add('DEBUG: $message');
  }

  @override
  void info(String message, {Object? data, StackTrace? stackTrace}) {
    logs.add('INFO: $message');
  }

  @override
  void warning(String message, {Object? data, StackTrace? stackTrace}) {
    logs.add('WARN: $message');
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    logs.add('ERROR: $message');
  }
}

/// In-memory storage alias for test readability.
typedef FakeStorage = InMemoryLocalStorage;

/// Records API requests without performing HTTP calls.
final class FakeApiClient implements ApiClient {
  FakeApiClient({this.responseFactory});

  final List<ApiRequest> requests = [];
  final Future<ApiResponse<T>> Function<T>(ApiRequest request)? responseFactory;

  @override
  Future<ApiResponse<T>> send<T>(ApiRequest request) async {
    requests.add(request);
    if (responseFactory != null) {
      return responseFactory!(request);
    }
    throw UnimplementedError('FakeApiClient: no responseFactory configured');
  }

  @override
  void addRequestInterceptor(RequestInterceptor interceptor) {}

  @override
  void addResponseInterceptor(ResponseInterceptor interceptor) {}

  @override
  void addErrorInterceptor(ErrorInterceptor interceptor) {}
}

/// Creates a [FakeClock] pinned to a fixed instant.
FakeClock createFakeClock([DateTime? at]) {
  return FakeClock(at ?? DateTime.utc(2026, 1, 1, 12));
}

/// Creates a resettable [FakeIdGenerator].
FakeIdGenerator createFakeIdGenerator({String prefix = 'test'}) {
  return FakeIdGenerator(prefix: prefix);
}
