import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'money.freezed.dart';
part 'money.g.dart';

/// Monetary amount stored in minor units (e.g. cents) to avoid floating-point error.
///
/// Maps to `DECIMAL(12,2)` in DATA_MODEL. Currency is ISO 4217 per restaurant.
@freezed
abstract class Money with _$Money {
  const Money._();

  const factory Money({
    /// Amount in minor currency units (USD cents, VND đồng if zero-decimal, etc.).
    required int amountMinor,
    /// ISO 4217 currency code, e.g. `USD`, `VND`.
    required String currencyCode,
  }) = _Money;

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);

  /// Creates [Money] from a decimal amount (2 fractional digits).
  factory Money.fromDecimal({
    required double amount,
    required String currencyCode,
  }) {
    if (currencyCode.length != 3) {
      throw const ValueObjectException(
        'Currency code must be ISO 4217 (3 letters)',
        code: 'INVALID_CURRENCY',
      );
    }
    return Money(
      amountMinor: (amount * 100).round(),
      currencyCode: currencyCode.toUpperCase(),
    );
  }

  /// Decimal representation for display (2 dp).
  double get amountDecimal => amountMinor / 100;

  /// Adds two [Money] values; currencies must match.
  Money operator +(Money other) {
    if (currencyCode != other.currencyCode) {
      throw const ValueObjectException(
        'Cannot add money with different currencies',
        code: 'CURRENCY_MISMATCH',
      );
    }
    return Money(
      amountMinor: amountMinor + other.amountMinor,
      currencyCode: currencyCode,
    );
  }

  /// Returns true if amount is zero.
  bool get isZero => amountMinor == 0;

  /// Returns true if amount is positive.
  bool get isPositive => amountMinor > 0;
}
