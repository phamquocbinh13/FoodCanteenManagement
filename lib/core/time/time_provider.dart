import '../clock/clock.dart';

/// Higher-level time operations built on [Clock].
///
/// Centralizes timeout, expiration, and scheduling calculations.
abstract interface class TimeProvider {
  DateTime get now;
  DateTime get today;

  bool isExpired(DateTime expiresAt, {Duration grace = Duration.zero});

  Duration elapsedSince(DateTime from);

  DateTime addDuration(DateTime from, Duration duration);
}

/// Default [TimeProvider] delegating to an injected [Clock].
final class ClockTimeProvider implements TimeProvider {
  ClockTimeProvider(this._clock);

  final Clock _clock;

  @override
  DateTime get now => _clock.now();

  @override
  DateTime get today => _clock.today();

  @override
  bool isExpired(DateTime expiresAt, {Duration grace = Duration.zero}) {
    return now.isAfter(expiresAt.add(grace));
  }

  @override
  Duration elapsedSince(DateTime from) => now.difference(from);

  @override
  DateTime addDuration(DateTime from, Duration duration) => from.add(duration);
}
