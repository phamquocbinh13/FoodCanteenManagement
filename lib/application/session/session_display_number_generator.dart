import '../../core/clock/clock.dart';

/// Generates human-readable session display numbers: S-YYYYMMDD-00023.
abstract final class SessionDisplayNumberGenerator {
  static String generate({
    required Clock clock,
    required int dailySequence,
  }) {
    final now = clock.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final seq = dailySequence.toString().padLeft(5, '0');
    return 'S-$y$m$d-$seq';
  }
}
