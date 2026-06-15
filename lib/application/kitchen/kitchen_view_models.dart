import '../../domain/enums/domain_enums.dart';

/// Kitchen-facing batch aggregate status derived from item states.
enum KitchenBatchDisplayStatus {
  pending,
  completed,
}

/// Kitchen-facing item row for large-touch KDS cards.
final class KitchenBatchItemViewModel {
  const KitchenBatchItemViewModel({
    required this.id,
    required this.name,
    required this.quantityLabel,
    required this.kitchenNotes,
    required this.status,
  });

  final String id;
  final String name;
  final String quantityLabel;
  final String kitchenNotes;
  final BatchItemStatus status;

  bool get isCompleted => status == BatchItemStatus.completed;
  bool get isActionable => status == BatchItemStatus.preparing;
}

/// Kitchen ticket card — no payment, customer, or session token data.
final class KitchenBatchViewModel {
  const KitchenBatchViewModel({
    required this.batchId,
    required this.batchNumber,
    required this.sessionDisplayNumber,
    required this.tableLabel,
    required this.createdAt,
    required this.items,
    required this.status,
    this.completedAt,
  });

  final String batchId;
  final int batchNumber;
  final String sessionDisplayNumber;
  final String tableLabel;
  final DateTime createdAt;
  final List<KitchenBatchItemViewModel> items;
  final KitchenBatchDisplayStatus status;
  final DateTime? completedAt;

  bool get isActive => status != KitchenBatchDisplayStatus.completed;
}

/// FIFO kitchen queue projection.
final class KitchenQueueView {
  const KitchenQueueView({
    required this.batches,
    required this.loadedAt,
  });

  final List<KitchenBatchViewModel> batches;
  final DateTime loadedAt;

  bool get isEmpty => batches.isEmpty;
}

/// Customer-visible batch progress (no item-level detail).
final class CustomerBatchProgressView {
  const CustomerBatchProgressView({
    required this.batchNumber,
    required this.statusLabel,
    required this.isCompleted,
  });

  final int batchNumber;
  final String statusLabel;
  final bool isCompleted;
}

/// Cashier read-only batch summary.
final class CashierBatchSummaryView {
  const CashierBatchSummaryView({
    required this.batchNumber,
    required this.statusLabel,
    required this.createdAt,
    this.completedAt,
  });

  final int batchNumber;
  final String statusLabel;
  final DateTime createdAt;
  final DateTime? completedAt;
}

/// Kitchen menu availability row.
final class KitchenMenuItemViewModel {
  const KitchenMenuItemViewModel({
    required this.id,
    required this.name,
    required this.isAvailable,
  });

  final String id;
  final String name;
  final bool isAvailable;
}
