import 'package:freezed_annotation/freezed_annotation.dart';

import '../exceptions/domain_exception.dart';

part 'table_qr_token.freezed.dart';

/// Opaque token encoded in physical QR: `/join/<token>`.
///
/// Must NOT expose table id. Backend resolves to [RestaurantTable].
/// Physical QR never changes; token hash stored in [TableQrTokenRecord].
@Freezed(fromJson: false, toJson: false)
abstract class TableQrToken with _$TableQrToken {
  const TableQrToken._();

  const factory TableQrToken(String value) = _TableQrToken;

  factory TableQrToken.fromJson(String json) => TableQrToken(_validate(json));

  String toJson() => value;

  static String _validate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < 32) {
      throw const ValueObjectException(
        'QR join token must be at least 32 characters',
        code: 'INVALID_QR_TOKEN',
      );
    }
    return trimmed;
  }
}
