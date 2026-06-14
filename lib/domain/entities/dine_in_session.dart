import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'dine_in_session.freezed.dart';
part 'dine_in_session.g.dart';

/// Heart of dine-in operations. Entity name: `Session` in DATA_MODEL §3.5.
///
/// Contains batches, timeline, requests, and closing payment. Dine-in only —
/// never linked to [RomsOrder]. Immutable after [SessionStatus.closed].
@freezed
abstract class DineInSession with _$DineInSession {
  const factory DineInSession({
    required String id,
    required String restaurantId,
    required String tableId,
    required int sessionNumber,
    @Default(SessionStatus.open) SessionStatus status,
    required SessionOpenedVia openedVia,
    String? openedByUserId,
    @Default(false) bool paymentSoftLock,
    required DateTime openedAt,
    DateTime? closedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DineInSession;

  factory DineInSession.fromJson(Map<String, dynamic> json) =>
      _$DineInSessionFromJson(json);
}
