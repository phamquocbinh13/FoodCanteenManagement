import 'dart:async';

/// Network reachability abstraction for future offline mode.
enum ConnectivityStatus {
  online,
  offline,
  unknown,
}

/// Monitors connectivity changes without coupling to a specific plugin.
abstract interface class ConnectivityService {
  ConnectivityStatus get currentStatus;

  Stream<ConnectivityStatus> get statusChanges;

  Future<bool> get isOnline;

  void dispose();
}

/// Stub connectivity service assuming online until plugin is integrated.
final class StubConnectivityService implements ConnectivityService {
  StubConnectivityService()
      : _controller = StreamController<ConnectivityStatus>.broadcast();

  final StreamController<ConnectivityStatus> _controller;
  ConnectivityStatus _status = ConnectivityStatus.online;

  @override
  ConnectivityStatus get currentStatus => _status;

  @override
  Stream<ConnectivityStatus> get statusChanges => _controller.stream;

  @override
  Future<bool> get isOnline async => _status == ConnectivityStatus.online;

  /// Test helper to simulate connectivity changes.
  void emit(ConnectivityStatus status) {
    _status = status;
    _controller.add(status);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
