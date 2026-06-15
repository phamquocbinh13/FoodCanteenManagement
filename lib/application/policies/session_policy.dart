import '../../core/errors/failures.dart';
import '../../core/result/result.dart';
import '../../domain/entities/session_auth_token.dart';
import '../../domain/enums/domain_enums.dart';
import 'policy.dart';

/// Session lifecycle business rules for the Session Engine.
final class SessionPolicy implements Policy<SessionPolicyContext, bool> {
  const SessionPolicy();

  Result<void> canCreate({
    required TableStatus tableStatus,
    required bool hasActiveSession,
  }) {
    if (hasActiveSession) {
      return const Err(
        ValidationFailure(
          'Table already has an active session',
          code: 'ACTIVE_SESSION_EXISTS',
        ),
      );
    }
    if (tableStatus == TableStatus.occupied) {
      return const Err(
        ValidationFailure(
          'Table is already occupied',
          code: 'TABLE_OCCUPIED',
        ),
      );
    }
    return const Success(null);
  }

  Result<void> canJoin({
    required SessionStatus status,
    required SessionAuthToken? token,
    required DateTime now,
  }) {
    if (status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    if (token == null) {
      return const Err(
        ValidationFailure(
          'Invalid session token',
          code: 'INVALID_SESSION_TOKEN',
        ),
      );
    }
    if (token.revokedAt != null) {
      return const Err(
        ValidationFailure(
          'Invalid session token',
          code: 'INVALID_SESSION_TOKEN',
        ),
      );
    }
    if (!token.expiresAt.isAfter(now)) {
      return const Err(
        ValidationFailure(
          'Session token has expired',
          code: 'SESSION_TOKEN_EXPIRED',
        ),
      );
    }
    return const Success(null);
  }

  Result<void> canClose({required SessionStatus status}) {
    if (status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    return const Success(null);
  }

  Result<void> canTransfer({required SessionStatus status}) {
    if (status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    return const Success(null);
  }

  Result<void> canAddBatch({required SessionStatus status}) {
    if (status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    if (status == SessionStatus.paymentPending) {
      return const Err(
        ValidationFailure(
          'Cannot add batch while waiting for payment',
          code: 'SESSION_PAYMENT_PENDING',
        ),
      );
    }
    return const Success(null);
  }

  Result<void> canRequestPayment({required SessionStatus status}) {
    if (status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    if (status == SessionStatus.paymentPending) {
      return const Err(
        ValidationFailure(
          'Session is already waiting for payment',
          code: 'SESSION_PAYMENT_PENDING',
        ),
      );
    }
    return const Success(null);
  }

  @override
  Result<bool> evaluate(SessionPolicyContext context) {
    return switch (canClose(status: context.status)) {
      Success<void>() => const Success(true),
      Err<void>(:final failure) => Err(failure),
    };
  }
}

final class SessionPolicyContext {
  const SessionPolicyContext({required this.status});

  final SessionStatus status;
}
