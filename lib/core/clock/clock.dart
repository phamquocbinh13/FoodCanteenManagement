/// Abstraction over system time for testable business logic.
///
/// Never call [DateTime.now] directly in domain, application, or repository code.
abstract interface class Clock {
  DateTime now();
}

/// Production clock delegating to the system clock.
final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Returns midnight UTC for the current clock day.
extension ClockDateExtension on Clock {
  DateTime today() {
    final current = now();
    return DateTime(current.year, current.month, current.day);
  }
}
