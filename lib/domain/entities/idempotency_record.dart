import 'package:freezed_annotation/freezed_annotation.dart';

part 'idempotency_record.freezed.dart';
part 'idempotency_record.g.dart';

/// Client mutation idempotency guard for distributed safety. DATA_MODEL §3.31.
///
/// Prevents duplicate batch confirm, payment close, or shipper claim on retry.
@freezed
abstract class IdempotencyRecord with _$IdempotencyRecord {
  const factory IdempotencyRecord({
    required String id,
    required String restaurantId,
    required String idempotencyKey,
    required String mutationType,
    required Map<String, dynamic> responseJson,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _IdempotencyRecord;

  factory IdempotencyRecord.fromJson(Map<String, dynamic> json) =>
      _$IdempotencyRecordFromJson(json);
}
