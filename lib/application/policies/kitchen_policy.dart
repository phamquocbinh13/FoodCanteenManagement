import '../../core/errors/failures.dart';
import '../../core/result/result.dart';
import 'policy.dart';

/// Kitchen visibility rules — batch-only, no payment data. Sprint 6.
final class KitchenPolicy implements Policy<KitchenPolicyContext, bool> {
  const KitchenPolicy();

  @override
  Result<bool> evaluate(KitchenPolicyContext context) {
    if (context.includesPaymentData) {
      return Err(
        ValidationFailure(
          'Kitchen projection must not include payment data',
          code: 'KITCHEN_VISIBILITY',
        ),
      );
    }
    return const Success(true);
  }
}

final class KitchenPolicyContext {
  const KitchenPolicyContext({required this.includesPaymentData});

  final bool includesPaymentData;
}
