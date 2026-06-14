import 'dart:async';

/// Application lifecycle states for reconnect and background sync.
enum AppLifecycleState {
  foreground,
  background,
  paused,
  resumed,
  detached,
}

/// Abstraction over Flutter/platform lifecycle for future reconnect logic.
abstract interface class AppLifecycleService {
  AppLifecycleState get currentState;

  Stream<AppLifecycleState> get stateChanges;

  void dispose();
}

/// Stub lifecycle service until platform wiring is added.
final class StubAppLifecycleService implements AppLifecycleService {
  StubAppLifecycleService()
      : _controller = StreamController<AppLifecycleState>.broadcast();

  final StreamController<AppLifecycleState> _controller;
  AppLifecycleState _state = AppLifecycleState.foreground;

  @override
  AppLifecycleState get currentState => _state;

  @override
  Stream<AppLifecycleState> get stateChanges => _controller.stream;

  /// Test helper to simulate lifecycle transitions.
  void emit(AppLifecycleState state) {
    _state = state;
    _controller.add(state);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
