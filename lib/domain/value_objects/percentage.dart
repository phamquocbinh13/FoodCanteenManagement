import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'percentage.freezed.dart';

/// Percentage stored as basis points (bps). 100 bps = 1%.
///
/// Used for tax and service charge in [RestaurantSettings].
@Freezed(fromJson: false, toJson: false)
abstract class Percentage with _$Percentage {
  const Percentage._();

  @Assert('basisPoints >= 0', 'Percentage cannot be negative')
  const factory Percentage(int basisPoints) = _Percentage;

  factory Percentage.fromJson(int json) {
    if (json < 0) {
      throw const ValueObjectException(
        'Percentage cannot be negative',
        code: 'INVALID_PERCENTAGE',
      );
    }
    return Percentage(json);
  }

  int toJson() => basisPoints;

  /// Decimal percentage, e.g. 1000 bps → 10.0%.
  double get asDecimal => basisPoints / 100;

  /// Apply percentage to [amountMinor] and return delta in minor units.
  int applyTo(int amountMinor) =>
      ((amountMinor * basisPoints) / 10000).round();
}
