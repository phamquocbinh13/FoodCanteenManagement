import '../../core/errors/failures.dart';
import '../../core/result/result.dart';
import 'policy.dart';

/// Payment close rules (no split bill, single close). Sprint 9.
final class PaymentPolicy implements Policy<PaymentPolicyContext, bool> {
  const PaymentPolicy();

  @override
  Result<bool> evaluate(PaymentPolicyContext context) {
    if (context.alreadyClosed) {
      return const Err(
        ValidationFailure('Session already paid', code: 'ALREADY_PAID'),
      );
    }
    return const Success(true);
  }
}

final class PaymentPolicyContext {
  const PaymentPolicyContext({required this.alreadyClosed});

  final bool alreadyClosed;
}
