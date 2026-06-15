import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import 'session_payment_summary.dart';

part 'dine_in_session.freezed.dart';
part 'dine_in_session.g.dart';

/// Heart of dine-in operations. Entity name: `Session` in DATA_MODEL §3.5.
///
/// Aggregate root for dine-in. Contains batches, timeline, requests, payment.
/// Immutable after [SessionStatus.closed].
@freezed
abstract class DineInSession with _$DineInSession {
  const factory DineInSession({
    required String id,
    required String restaurantId,
    required String tableId,
    required int sessionNumber,
    required String displayNumber,
    @Default(SessionStatus.open) SessionStatus status,
    required SessionOpenedVia openedVia,
    String? openedByUserId,
    String? closedByUserId,
    @Default(false) bool paymentSoftLock,
    @Default(0) int currentBatchNumber,
    @Default(SessionPaymentStatus.unpaid) SessionPaymentStatus paymentStatus,
    SessionPaymentSummary? paymentSummary,
    required DateTime openedAt,
    DateTime? closedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DineInSession;

  factory DineInSession.fromJson(Map<String, dynamic> json) =>
      _$DineInSessionFromJson(json);
}
