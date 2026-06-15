import '../../domain/entities/batch_item.dart';
import '../../domain/entities/kitchen_batch.dart';

/// Kitchen-facing batch ticket (Sprint 6 consumption).
final class KitchenBatchTicket {
  const KitchenBatchTicket({
    required this.batch,
    required this.tableLabel,
    required this.items,
  });

  final KitchenBatch batch;
  final String tableLabel;
  final List<BatchItem> items;
}
