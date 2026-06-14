import '../entities/delivery_detail.dart';
import '../entities/roms_order.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Take Away and Delivery order pipeline rules.
///
/// [RomsOrder] never mixes with [DineInSession]. Delivery uses [DeliveryDetail].
class OrderDomainService {
  const OrderDomainService();

  /// Validates order type is non-dine-in channel.
  void validateOrderType(OrderType type) {
    if (type != OrderType.takeaway && type != OrderType.delivery) {
      throw const OrderRuleException(
        'Invalid order type for RomsOrder',
        code: 'INVALID_ORDER_TYPE',
      );
    }
  }

  /// Delivery orders must have delivery detail.
  void validateDeliveryOrder({
    required RomsOrder order,
    DeliveryDetail? detail,
  }) {
    if (order.orderType != OrderType.delivery) return;
    if (detail == null) {
      throw const OrderRuleException(
        'Delivery order requires DeliveryDetail',
        code: 'DELIVERY_DETAIL_REQUIRED',
      );
    }
  }

  /// Whether order can be submitted to kitchen.
  bool canSubmitToKitchen({
    required RomsOrder order,
    required int lineCount,
  }) {
    return order.status == OrderStatus.draft && lineCount > 0;
  }

  void validateSubmitToKitchen({
    required RomsOrder order,
    required int lineCount,
  }) {
    if (lineCount == 0) {
      throw const OrderRuleException(
        'Cannot submit empty order',
        code: 'EMPTY_ORDER',
      );
    }
    if (order.status != OrderStatus.draft) {
      throw OrderRuleException(
        'Order cannot be submitted from status ${order.status.name}',
        code: 'INVALID_ORDER_STATUS',
      );
    }
  }

  /// Mark order submitted (batch will be created by application layer).
  RomsOrder markSubmitted(RomsOrder order, {required int lineCount}) {
    validateSubmitToKitchen(order: order, lineCount: lineCount);
    final now = DateTime.now().toUtc();
    return order.copyWith(
      status: OrderStatus.submitted,
      submittedAt: now,
      updatedAt: now,
    );
  }
}
