import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Validates legal [SessionStatus] transitions for the Session Engine.
///
/// Sprint lifecycle mapping:
/// Available (no session) → Occupied ([open]) → WaitingPayment ([paymentPending])
/// → Closed ([closed]).
abstract final class SessionStateMachine {
  static SessionLifecyclePhase phaseFor(SessionStatus? status) {
    if (status == null) return SessionLifecyclePhase.available;
    return status.lifecyclePhase;
  }

  static bool canTransition(SessionStatus? from, SessionStatus to) {
    final fromPhase = phaseFor(from);
    final toPhase = to.lifecyclePhase;

    return switch ((fromPhase, toPhase)) {
      (SessionLifecyclePhase.available, SessionLifecyclePhase.occupied) => true,
      (SessionLifecyclePhase.occupied, SessionLifecyclePhase.waitingPayment) =>
        true,
      (SessionLifecyclePhase.waitingPayment, SessionLifecyclePhase.closed) =>
        true,
      (SessionLifecyclePhase.occupied, SessionLifecyclePhase.closed) => true,
      _ => false,
    };
  }

  static SessionStatus transition(SessionStatus from, SessionStatus to) {
    if (!canTransition(from, to)) {
      throw SessionRuleException(
        'Invalid session transition: ${from.name} → ${to.name}',
        code: 'INVALID_SESSION_TRANSITION',
      );
    }
    return to;
  }
}

extension SessionStatusLifecycle on SessionStatus {
  SessionLifecyclePhase get lifecyclePhase => switch (this) {
        SessionStatus.open => SessionLifecyclePhase.occupied,
        SessionStatus.paymentPending => SessionLifecyclePhase.waitingPayment,
        SessionStatus.closed => SessionLifecyclePhase.closed,
      };
}
