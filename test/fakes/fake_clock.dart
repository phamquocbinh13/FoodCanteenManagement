import 'package:food_canteen_management/core/clock/clock.dart';

/// Deterministic clock for unit and integration tests.
final class FakeClock implements Clock {
  FakeClock(this._fixed);

  DateTime _fixed;

  @override
  DateTime now() => _fixed;

  void set(DateTime value) => _fixed = value;

  void advance(Duration duration) => _fixed = _fixed.add(duration);
}
