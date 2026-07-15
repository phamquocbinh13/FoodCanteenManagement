import '../../domain/entities/batch_item.dart';
import '../../domain/entities/session_payment_summary.dart';

/// Derives session payment summary from immutable batch line snapshots.
///
/// Batch data is the source of truth; payment summary is a projection only.
final class SessionBillProjector {
  const SessionBillProjector();

  int batchSubtotalMinor(Iterable<BatchItem> items) {
    var subtotalMinor = 0;
    for (final item in items) {
      subtotalMinor += item.lineTotal.amountMinor;
    }
    return subtotalMinor;
  }

  SessionPaymentSummary project({
    required SessionPaymentSummary? existing,
    required int batchSubtotalMinor,
    int openCartSubtotalMinor = 0,
  }) {
    return (existing ?? const SessionPaymentSummary())
        .copyWith(subtotalMinor: batchSubtotalMinor + openCartSubtotalMinor)
        .recalculateTotal();
  }
}
