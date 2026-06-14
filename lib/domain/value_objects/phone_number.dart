import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'phone_number.freezed.dart';

/// Customer phone number for takeaway/delivery orders.
///
/// Stored as normalized digits with optional leading `+`.
@Freezed(fromJson: false, toJson: false)
abstract class PhoneNumber with _$PhoneNumber {
  const PhoneNumber._();

  const factory PhoneNumber(String value) = _PhoneNumber;

  factory PhoneNumber.fromJson(String json) => PhoneNumber(_normalize(json));

  String toJson() => value;

  static String _normalize(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValueObjectException(
        'Phone number cannot be empty',
        code: 'INVALID_PHONE',
      );
    }
    final digits = trimmed.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.length < 7 || digits.length > 20) {
      throw const ValueObjectException(
        'Phone number length invalid',
        code: 'INVALID_PHONE',
      );
    }
    return digits;
  }
}
