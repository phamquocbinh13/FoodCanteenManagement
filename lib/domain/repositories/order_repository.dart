import '../entities/delivery_detail.dart';
import '../entities/order_line.dart';
import '../entities/roms_order.dart';

/// Persistence contract for takeaway/delivery [RomsOrder] aggregate.
abstract interface class OrderRepository {
  Future<RomsOrder> create(RomsOrder order);

  Future<RomsOrder?> findById({
    required String restaurantId,
    required String orderId,
  });

  Future<RomsOrder> update(RomsOrder order);

  Future<List<OrderLine>> getLines(String orderId);

  Future<OrderLine> addLine(OrderLine line);

  Future<void> removeLine(String orderId, String lineId);

  Future<DeliveryDetail?> findDeliveryDetail(String orderId);

  Future<DeliveryDetail> createDeliveryDetail(DeliveryDetail detail);

  Future<DeliveryDetail> updateDeliveryDetail(DeliveryDetail detail);

  Future<List<RomsOrder>> listDeliveryOrdersForShipper(String restaurantId);

  Future<int> nextOrderNumber(String restaurantId);
}
