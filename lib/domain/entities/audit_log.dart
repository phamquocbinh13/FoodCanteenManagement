import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

/// Append-only polymorphic audit trail. DATA_MODEL §3.28.
///
/// Logs session, batch, payment, menu, kitchen, delivery, and user actions.
@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String restaurantId,
    required ActorType actorType,
    String? actorId,
    required String entityType,
    required String entityId,
    required AuditAction action,
    Map<String, dynamic>? beforeJson,
    Map<String, dynamic>? afterJson,
    @Default({}) Map<String, dynamic> metadataJson,
    required DateTime occurredAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
