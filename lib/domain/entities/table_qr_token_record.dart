import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_qr_token_record.freezed.dart';
part 'table_qr_token_record.g.dart';

/// Persistent QR join token record. Entity name: `TableQrToken` in DATA_MODEL §3.4.
///
/// Stores SHA-256 hash of opaque [TableQrToken] value object. One active token
/// per [RestaurantTable]. Physical QR never exposes table id.
@freezed
abstract class TableQrTokenRecord with _$TableQrTokenRecord {
  const factory TableQrTokenRecord({
    required String id,
    required String restaurantId,
    required String tableId,
    required String tokenHash,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _TableQrTokenRecord;

  factory TableQrTokenRecord.fromJson(Map<String, dynamic> json) =>
      _$TableQrTokenRecordFromJson(json);
}
