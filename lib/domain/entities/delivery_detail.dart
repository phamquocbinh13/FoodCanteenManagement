import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'delivery_detail.freezed.dart';
part 'delivery_detail.g.dart';

/// Delivery-specific lifecycle and shipper assignment. DATA_MODEL §3.17.
///
/// 1:1 with [RomsOrder] where [OrderType.delivery]. Shipper claim is exclusive.
@freezed
abstract class DeliveryDetail with _$DeliveryDetail {
  const factory DeliveryDetail({
    required String id,
    required String orderId,
    @Default(DeliveryStatus.pending) DeliveryStatus deliveryStatus,
    required String deliveryAddress,
    String? deliveryNotes,
    String? shipperUserId,
    DateTime? readyAt,
    DateTime? claimedAt,
    DateTime? deliveringAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeliveryDetail;

  factory DeliveryDetail.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDetailFromJson(json);
}
