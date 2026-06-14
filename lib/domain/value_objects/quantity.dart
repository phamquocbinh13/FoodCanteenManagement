import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'quantity.freezed.dart';

/// Positive integer quantity for cart lines and batch items.
///
/// Avoids primitive obsession on raw `int` counts.
@Freezed(fromJson: false, toJson: false)
abstract class Quantity with _$Quantity {
  const Quantity._();

  @Assert('value > 0', 'Quantity must be greater than zero')
  const factory Quantity(int value) = _Quantity;

  factory Quantity.fromJson(int json) {
    if (json <= 0) {
      throw const ValueObjectException(
        'Quantity must be greater than zero',
        code: 'INVALID_QUANTITY',
      );
    }
    return Quantity(json);
  }

  int toJson() => value;
}
