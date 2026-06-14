import '../entities/batch_item.dart';
import '../entities/kitchen_batch.dart';
import '../entities/session_cart_item.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Encapsulates [KitchenBatch] immutability and parent XOR rules.
///
/// Every confirm creates exactly one new batch. Never modify or merge batches.
class BatchDomainService {
  const BatchDomainService();

  /// Validates XOR parent: exactly one of sessionId or orderId.
  void validateParentXor(KitchenBatch batch) {
    final hasSession = batch.sessionId != null;
    final hasOrder = batch.orderId != null;
    if (hasSession == hasOrder) {
      throw const BatchRuleException(
        'Batch must have exactly one parent: sessionId XOR orderId',
        code: 'INVALID_BATCH_PARENT',
      );
    }
  }

  /// Validates batch before persistence.
  void validateNewBatch(KitchenBatch batch) {
    validateParentXor(batch);
    if (batch.batchNumber < 1) {
      throw const BatchRuleException(
        'Batch number must be positive',
        code: 'INVALID_BATCH_NUMBER',
      );
    }
  }

  /// Whether batch content can be mutated (never, except item status).
  bool isBatchContentImmutable(KitchenBatch batch) => true;

  /// Validates cart has items before batch creation.
  void validateCartNotEmpty(List<SessionCartItem> items) {
    if (items.isEmpty) {
      throw const BatchRuleException(
        'Cannot create batch from empty cart',
        code: 'EMPTY_CART',
      );
    }
  }

  /// Validates legal [BatchItemStatus] transition.
  bool canTransitionItemStatus(BatchItemStatus from, BatchItemStatus to) {
    if (from == to) return true;
    return switch ((from, to)) {
      (BatchItemStatus.preparing, BatchItemStatus.completed) => true,
      (BatchItemStatus.completed, BatchItemStatus.served) => true,
      (BatchItemStatus.preparing, BatchItemStatus.served) => true,
      _ => false,
    };
  }

  /// Returns updated item or throws [KitchenRuleException].
  BatchItem transitionItemStatus(BatchItem item, BatchItemStatus to) {
    if (!canTransitionItemStatus(item.status, to)) {
      throw KitchenRuleException(
        'Illegal batch item status: ${item.status.name} → ${to.name}',
        code: 'INVALID_ITEM_STATUS',
      );
    }
    return item.copyWith(
      status: to,
      statusUpdatedAt: DateTime.now().toUtc(),
    );
  }
}
