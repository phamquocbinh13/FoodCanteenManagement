import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'staff_request.freezed.dart';
part 'staff_request.g.dart';

/// Customer call-staff request (request queue). DATA_MODEL §3.11.
///
/// Payment request is a queue entry — not payment itself. Cashier handles.
/// Belongs to [DineInSession] only.
@freezed
abstract class StaffRequest with _$StaffRequest {
  const factory StaffRequest({
    required String id,
    required String restaurantId,
    required String sessionId,
    required RequestType requestType,
    @Default(RequestStatus.pending) RequestStatus status,
    String? note,
    required DateTime requestedAt,
    DateTime? handledAt,
    String? handledByUserId,
    required DateTime createdAt,
  }) = _StaffRequest;

  factory StaffRequest.fromJson(Map<String, dynamic> json) =>
      _$StaffRequestFromJson(json);
}
