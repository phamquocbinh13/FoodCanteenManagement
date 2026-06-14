import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';
import '../value_objects/json_converters.dart';
import '../value_objects/phone_number.dart';

part 'roms_order.freezed.dart';
part 'roms_order.g.dart';

/// Take Away or Delivery order. Entity name: `Order` in DATA_MODEL §3.15.
///
/// Never references [DineInSession] or [RestaurantTable]. Cashier creates.
/// Do not mix with dine-in session pipeline.
@freezed
abstract class RomsOrder with _$RomsOrder {
  const factory RomsOrder({
    required String id,
    required String restaurantId,
    required int orderNumber,
    required OrderType orderType,
    @Default(OrderStatus.draft) OrderStatus status,
    String? customerName,
    @PhoneNumberConverter() PhoneNumber? customerPhone,
    String? notes,
    required String createdByUserId,
    DateTime? submittedAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RomsOrder;

  factory RomsOrder.fromJson(Map<String, dynamic> json) =>
      _$RomsOrderFromJson(json);
}
