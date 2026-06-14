import '../entities/batch_item.dart';
import '../entities/kitchen_batch.dart';
import '../entities/restaurant_table.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';
import 'batch_domain_service.dart';

/// Kitchen projection and item status rules.
///
/// Kitchen only works with [KitchenBatch] / [BatchItem]. Never sees bill,
/// payment, or session totals per PROJECT_CONTEXT.
class KitchenDomainService {
  const KitchenDomainService();

  /// Data allowed in kitchen queue projection.
  ///
  /// Intentionally excludes payment and bill fields.
  bool isKitchenSafeBatch(KitchenBatch batch) {
    return batch.sessionId != null || batch.orderId != null;
  }

  /// Kitchen may update item to preparing, completed, or served.
  bool canKitchenUpdateStatus(BatchItemStatus status) => true;

  /// Validates kitchen status update request.
  BatchItem validateAndTransitionItemStatus({
    required BatchItem item,
    required BatchItemStatus newStatus,
    BatchDomainService batchService = const BatchDomainService(),
  }) {
    if (!canKitchenUpdateStatus(newStatus)) {
      throw const KitchenRuleException(
        'Kitchen cannot set this status',
        code: 'KITCHEN_STATUS_FORBIDDEN',
      );
    }
    return batchService.transitionItemStatus(item, newStatus);
  }

  /// Optional table label for dine-in kitchen display (no payment data).
  String? resolveTableLabel({
    required KitchenBatch batch,
    RestaurantTable? table,
  }) {
    if (batch.sessionId == null) return null;
    return table?.label;
  }

  /// Whether all items in batch reached completed or served.
  bool isBatchKitchenComplete(List<BatchItem> items) {
    if (items.isEmpty) return false;
    return items.every(
      (i) =>
          i.status == BatchItemStatus.completed ||
          i.status == BatchItemStatus.served,
    );
  }
}
