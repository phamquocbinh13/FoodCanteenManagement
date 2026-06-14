import '../../core/errors/failures.dart';
import '../../core/result/result.dart';
import '../../domain/enums/domain_enums.dart';
import 'policy.dart';

/// Session lifecycle business rules. Full rules wired in Sprint 3.
final class SessionPolicy implements Policy<SessionPolicyContext, bool> {
  const SessionPolicy();

  @override
  Result<bool> evaluate(SessionPolicyContext context) {
    if (context.status == SessionStatus.closed) {
      return const Err(
        ValidationFailure('Session is closed', code: 'SESSION_CLOSED'),
      );
    }
    return const Success(true);
  }
}

final class SessionPolicyContext {
  const SessionPolicyContext({required this.status});

  final SessionStatus status;
}
