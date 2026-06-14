import '../../core/result/result.dart';

/// Encapsulates a business rule decision outside UI and widgets.
abstract interface class Policy<TContext, TDecision> {
  Result<TDecision> evaluate(TContext context);
}

/// No-op policy that always permits the action.
final class AllowAllPolicy<TContext> implements Policy<TContext, bool> {
  const AllowAllPolicy();

  @override
  Result<bool> evaluate(TContext context) => const Success(true);
}
