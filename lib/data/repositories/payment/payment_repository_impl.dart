import '../../../domain/entities/order_payment.dart';
import '../../../domain/entities/session_bill_line.dart';
import '../../../domain/entities/session_payment.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../../datasources/payment/payment_datasource.dart';

final class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required PaymentRemoteDataSource remote})
      : _remote = remote;

  // ignore: unused_field
  final PaymentRemoteDataSource _remote;

  Never _notImplemented(String method) =>
      throw UnimplementedError('PaymentRepositoryImpl.$method');

  @override
  Future<SessionPayment?> findSessionPaymentBySessionId(String sessionId) =>
      _notImplemented('findSessionPaymentBySessionId');

  @override
  Future<SessionPayment> createSessionPayment(SessionPayment payment) =>
      _notImplemented('createSessionPayment');

  @override
  Future<void> createSessionBillLines(List<SessionBillLine> lines) =>
      _notImplemented('createSessionBillLines');

  @override
  Future<List<SessionBillLine>> getBillLinesByPaymentId(
    String sessionPaymentId,
  ) =>
      _notImplemented('getBillLinesByPaymentId');

  @override
  Future<OrderPayment?> findOrderPaymentByOrderId(String orderId) =>
      _notImplemented('findOrderPaymentByOrderId');

  @override
  Future<OrderPayment> createOrderPayment(OrderPayment payment) =>
      _notImplemented('createOrderPayment');
}
