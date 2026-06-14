import '../entities/order_payment.dart';
import '../entities/session_bill_line.dart';
import '../entities/session_payment.dart';

/// Persistence contract for payment snapshots (dine-in and order).
abstract interface class PaymentRepository {
  Future<SessionPayment?> findSessionPaymentBySessionId(String sessionId);

  Future<SessionPayment> createSessionPayment(SessionPayment payment);

  Future<void> createSessionBillLines(List<SessionBillLine> lines);

  Future<List<SessionBillLine>> getBillLinesByPaymentId(String sessionPaymentId);

  Future<OrderPayment?> findOrderPaymentByOrderId(String orderId);

  Future<OrderPayment> createOrderPayment(OrderPayment payment);
}
