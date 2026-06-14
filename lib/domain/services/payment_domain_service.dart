import '../entities/batch_item.dart';
import '../entities/dine_in_session.dart';
import '../entities/restaurant_settings.dart';
import '../entities/session_payment.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';
import '../value_objects/money.dart';

/// Bill calculation and session close payment rules.
///
/// No split bill. One [SessionPayment] per [DineInSession]. Only cashier/admin.
class PaymentDomainService {
  const PaymentDomainService();

  /// Calculates bill from batch line items with tax and service charge.
  ({
    Money subtotal,
    Money taxAmount,
    Money serviceChargeAmount,
    Money totalAmount,
  }) calculateSessionBill({
    required List<BatchItem> batchItems,
    required RestaurantSettings settings,
  }) {
    if (batchItems.isEmpty) {
      throw const PaymentRuleException(
        'Cannot calculate bill with no batch items',
        code: 'EMPTY_BILL',
      );
    }
    final currency = settings.defaultCurrency;
    var subtotalMinor = 0;
    for (final item in batchItems) {
      if (item.lineTotal.currencyCode != currency) {
        throw PaymentRuleException(
          'Currency mismatch on batch item ${item.id}',
          code: 'CURRENCY_MISMATCH',
        );
      }
      subtotalMinor += item.lineTotal.amountMinor;
    }
    final subtotal = Money(amountMinor: subtotalMinor, currencyCode: currency);
    final taxMinor = settings.taxRateBps.applyTo(subtotalMinor);
    final serviceMinor = settings.serviceChargeBps.applyTo(subtotalMinor);
    final totalMinor = subtotalMinor + taxMinor + serviceMinor;
    return (
      subtotal: subtotal,
      taxAmount: Money(amountMinor: taxMinor, currencyCode: currency),
      serviceChargeAmount: Money(
        amountMinor: serviceMinor,
        currencyCode: currency,
      ),
      totalAmount: Money(amountMinor: totalMinor, currencyCode: currency),
    );
  }

  /// Validates normal payment close.
  void validatePaymentClose({
    required DineInSession session,
    required SessionPayment? existingPayment,
  }) {
    if (session.status == SessionStatus.closed) {
      throw const PaymentRuleException(
        'Session is already closed',
        code: 'SESSION_ALREADY_CLOSED',
      );
    }
    if (existingPayment != null) {
      throw const PaymentRuleException(
        'Session already has payment — no split bill',
        code: 'PAYMENT_EXISTS',
      );
    }
  }

  /// Validates admin force-close payment record.
  void validateForceClose({
    required DineInSession session,
    required SessionPayment? existingPayment,
    required ForceCloseReason? reason,
    required SessionCloseType closeType,
  }) {
    if (existingPayment != null) {
      throw const PaymentRuleException(
        'Session already has payment record',
        code: 'PAYMENT_EXISTS',
      );
    }
    if (closeType == SessionCloseType.forceClosed && reason == null) {
      throw const PaymentRuleException(
        'Force close requires a reason',
        code: 'FORCE_CLOSE_REASON_REQUIRED',
      );
    }
    if (session.status == SessionStatus.closed) {
      throw const PaymentRuleException(
        'Session is already closed',
        code: 'SESSION_ALREADY_CLOSED',
      );
    }
  }

  /// Builds immutable [SessionPayment] snapshot (no split bill).
  SessionPayment buildSessionPayment({
    required String id,
    required String sessionId,
    required PaymentMethod paymentMethod,
    required Money subtotal,
    required Money taxAmount,
    required Money serviceChargeAmount,
    required Money totalAmount,
    required String closedByUserId,
    SessionCloseType closeType = SessionCloseType.payment,
    ForceCloseReason? forceCloseReason,
    String? forceCloseNote,
    DateTime? paidAt,
  }) {
    return SessionPayment(
      id: id,
      sessionId: sessionId,
      paymentMethod: paymentMethod,
      closeType: closeType,
      forceCloseReason: forceCloseReason,
      forceCloseNote: forceCloseNote,
      subtotal: subtotal,
      taxAmount: taxAmount,
      serviceChargeAmount: serviceChargeAmount,
      totalAmount: totalAmount,
      closedByUserId: closedByUserId,
      paidAt: paidAt ?? DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
    );
  }
}
