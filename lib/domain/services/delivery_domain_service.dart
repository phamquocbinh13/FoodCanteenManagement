import '../entities/delivery_detail.dart';
import '../entities/roms_order.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Shipper claim and delivery lifecycle rules.
///
/// Only delivery orders visible to shipper. Claim is exclusive.
class DeliveryDomainService {
  const DeliveryDomainService();

  /// Shipper can only interact with delivery orders.
  void validateShipperOrder(RomsOrder order) {
    if (order.orderType != OrderType.delivery) {
      throw const OrderRuleException(
        'Shipper only sees delivery orders',
        code: 'NOT_DELIVERY_ORDER',
      );
    }
  }

  /// Whether order is available for claim.
  bool canClaim(DeliveryDetail detail) {
    return detail.deliveryStatus == DeliveryStatus.ready &&
        detail.shipperUserId == null;
  }

  /// Exclusive claim — locks order to shipper.
  DeliveryDetail claim({
    required DeliveryDetail detail,
    required String shipperUserId,
  }) {
    if (!canClaim(detail)) {
      throw const OrderRuleException(
        'Delivery is not available for claim',
        code: 'CLAIM_NOT_AVAILABLE',
      );
    }
    final now = DateTime.now().toUtc();
    return detail.copyWith(
      deliveryStatus: DeliveryStatus.claimed,
      shipperUserId: shipperUserId,
      claimedAt: now,
      updatedAt: now,
    );
  }

  /// Admin/cashier reassignment resets to ready.
  DeliveryDetail reassign(DeliveryDetail detail) {
    if (detail.deliveryStatus == DeliveryStatus.completed) {
      throw const OrderRuleException(
        'Cannot reassign completed delivery',
        code: 'DELIVERY_COMPLETED',
      );
    }
    final now = DateTime.now().toUtc();
    return detail.copyWith(
      deliveryStatus: DeliveryStatus.ready,
      shipperUserId: null,
      claimedAt: null,
      deliveringAt: null,
      updatedAt: now,
    );
  }

  /// Shipper marks en route.
  DeliveryDetail markDelivering(DeliveryDetail detail, String shipperUserId) {
    if (detail.shipperUserId != shipperUserId) {
      throw const OrderRuleException(
        'Only assigned shipper can mark delivering',
        code: 'SHIPPER_MISMATCH',
      );
    }
    if (detail.deliveryStatus != DeliveryStatus.claimed) {
      throw const OrderRuleException(
        'Delivery must be claimed before delivering',
        code: 'INVALID_DELIVERY_STATUS',
      );
    }
    final now = DateTime.now().toUtc();
    return detail.copyWith(
      deliveryStatus: DeliveryStatus.delivering,
      deliveringAt: now,
      updatedAt: now,
    );
  }

  /// Terminal delivered state.
  DeliveryDetail markCompleted(DeliveryDetail detail, String shipperUserId) {
    if (detail.shipperUserId != shipperUserId) {
      throw const OrderRuleException(
        'Only assigned shipper can complete delivery',
        code: 'SHIPPER_MISMATCH',
      );
    }
    final now = DateTime.now().toUtc();
    return detail.copyWith(
      deliveryStatus: DeliveryStatus.completed,
      completedAt: now,
      updatedAt: now,
    );
  }

  /// Kitchen ready for shipper pickup.
  DeliveryDetail markReady(DeliveryDetail detail) {
    final now = DateTime.now().toUtc();
    return detail.copyWith(
      deliveryStatus: DeliveryStatus.ready,
      readyAt: now,
      updatedAt: now,
    );
  }
}
