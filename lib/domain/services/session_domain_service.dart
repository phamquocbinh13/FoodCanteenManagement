import '../entities/dine_in_session.dart';
import '../entities/restaurant_settings.dart';
import '../entities/restaurant_table.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Encapsulates dine-in [DineInSession] lifecycle business rules.
///
/// Session is the heart of dine-in. Ends only on payment or admin force-close.
/// Immutable after [SessionStatus.closed].
class SessionDomainService {
  const SessionDomainService();

  /// Whether session accepts new cart operations.
  bool canModifyCart(DineInSession session) {
    return session.status == SessionStatus.open && !session.paymentSoftLock;
  }

  /// Whether customer can confirm a new batch.
  bool canConfirmBatch({
    required DineInSession session,
    required RestaurantSettings settings,
    required int cartItemCount,
  }) {
    if (cartItemCount == 0) {
      return false;
    }
    if (session.status == SessionStatus.closed) {
      return false;
    }
    if (session.status == SessionStatus.paymentPending) {
      return false;
    }
    if (settings.paymentSoftLockEnabled && session.paymentSoftLock) {
      return false;
    }
    return session.status == SessionStatus.open;
  }

  /// Validates batch confirm; throws [SessionRuleException] if blocked.
  void validateCanConfirmBatch({
    required DineInSession session,
    required RestaurantSettings settings,
    required int cartItemCount,
  }) {
    if (cartItemCount == 0) {
      throw const SessionRuleException(
        'Cannot confirm an empty cart',
        code: 'EMPTY_CART',
      );
    }
    if (!canConfirmBatch(
      session: session,
      settings: settings,
      cartItemCount: cartItemCount,
    )) {
      throw SessionRuleException(
        'Session does not accept new batches (status: ${session.status.name})',
        code: 'SESSION_LOCKED',
      );
    }
  }

  /// Whether session is terminal and immutable.
  bool isClosed(DineInSession session) =>
      session.status == SessionStatus.closed;

  /// Apply payment-request soft lock per settings.
  DineInSession applyPaymentRequest(DineInSession session) {
    if (isClosed(session)) {
      throw const SessionRuleException(
        'Cannot request payment on closed session',
        code: 'SESSION_CLOSED',
      );
    }
    return session.copyWith(
      status: SessionStatus.paymentPending,
      paymentSoftLock: true,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Close session after payment (terminal state).
  DineInSession closeAfterPayment(DineInSession session) {
    if (isClosed(session)) {
      throw const SessionRuleException(
        'Session is already closed',
        code: 'SESSION_ALREADY_CLOSED',
      );
    }
    final now = DateTime.now().toUtc();
    return session.copyWith(
      status: SessionStatus.closed,
      closedAt: now,
      updatedAt: now,
    );
  }

  /// Admin force-close (terminal state).
  DineInSession forceClose(DineInSession session) {
    if (isClosed(session)) {
      throw const SessionRuleException(
        'Session is already closed',
        code: 'SESSION_ALREADY_CLOSED',
      );
    }
    final now = DateTime.now().toUtc();
    return session.copyWith(
      status: SessionStatus.closed,
      closedAt: now,
      updatedAt: now,
    );
  }

  /// Validates opening session on table.
  void validateCanOpenSession({
    required RestaurantTable table,
    required DineInSession? existingActiveSession,
    required bool allowQrOnReservedTable,
    required SessionOpenedVia openedVia,
  }) {
    if (existingActiveSession != null) {
      throw const SessionRuleException(
        'Table already has an active session',
        code: 'ACTIVE_SESSION_EXISTS',
      );
    }
    if (openedVia == SessionOpenedVia.qrScan &&
        table.status == TableStatus.reserved &&
        !allowQrOnReservedTable) {
      throw const SessionRuleException(
        'QR join not allowed on reserved table',
        code: 'TABLE_RESERVED',
      );
    }
    if (!table.isActive) {
      throw const SessionRuleException(
        'Table is not active',
        code: 'TABLE_INACTIVE',
      );
    }
  }
}
