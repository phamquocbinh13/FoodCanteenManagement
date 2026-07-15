import '../entities/batch_item.dart';
import '../entities/batch_item_customization.dart';
import '../entities/batch_item_status_history.dart';
import '../entities/kitchen_batch.dart';

/// Persistence contract for immutable [KitchenBatch] aggregate.
abstract interface class BatchRepository {
  Future<KitchenBatch> create(KitchenBatch batch);

  Future<KitchenBatch?> findById({
    required String restaurantId,
    required String batchId,
  });

  Future<List<KitchenBatch>> listKitchenQueue({
    required String restaurantId,
    DateTime? since,
  });

  Future<List<KitchenBatch>> listBySession({
    required String restaurantId,
    required String sessionId,
  });

  Future<List<BatchItem>> getItemsByBatchId(String batchId);

  Future<BatchItem> createItem(BatchItem item);

  Future<BatchItem> updateItemStatus(BatchItem item);

  Future<BatchItem?> findItemById({
    required String restaurantId,
    required String batchItemId,
  });

  Future<DateTime?> getBatchCompletedAt(String batchId);

  Future<void> markBatchCompleted({
    required String batchId,
    required DateTime completedAt,
  });

  Future<List<BatchItemCustomization>> getCustomizationsByItemId(
    String batchItemId,
  );

  Future<void> createCustomizations(List<BatchItemCustomization> customizations);

  Future<BatchItemStatusHistory> recordStatusHistory(
    BatchItemStatusHistory history,
  );

  Future<int> nextBatchNumber({
    required String restaurantId,
    String? sessionId,
    String? orderId,
  });
}
