import '../../data/datasources/ordering/ordering_store.dart';
import '../../domain/entities/session_payment_summary.dart';

/// Derives session payment summary from immutable batch line snapshots.
///
/// Batch data is the source of truth; payment summary is a projection only.
final class SessionBillProjector {
  const SessionBillProjector({required OrderingStore store}) : _store = store;

  final OrderingStore _store;

  int batchSubtotalMinor(String sessionId) {
    var subtotalMinor = 0;
    for (final batch in _store.batchesForSession(sessionId)) {
      final items = _store.batchItemsByBatchId[batch.id] ?? [];
      for (final item in items) {
        subtotalMinor += item.lineTotal.amountMinor;
      }
    }
    return subtotalMinor;
  }

  SessionPaymentSummary project({
    required SessionPaymentSummary? existing,
    required String sessionId,
    int openCartSubtotalMinor = 0,
  }) {
    final batchSubtotal = batchSubtotalMinor(sessionId);
    return (existing ?? const SessionPaymentSummary())
        .copyWith(subtotalMinor: batchSubtotal + openCartSubtotalMinor)
        .recalculateTotal();
  }
}
