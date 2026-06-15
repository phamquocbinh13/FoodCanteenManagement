import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/batch_item_customization.dart';
import '../../../domain/entities/batch_item_status_history.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../datasources/ordering/ordering_store.dart';

/// In-memory batch repository backed by [OrderingStore].
final class BatchRepositoryImpl implements BatchRepository {
  BatchRepositoryImpl({required OrderingStore store}) : _store = store;

  final OrderingStore _store;

  @override
  Future<KitchenBatch> create(KitchenBatch batch) async {
    _store.batches[batch.id] = batch;
    _store.batchItemsByBatchId.putIfAbsent(batch.id, () => []);
    return batch;
  }

  @override
  Future<KitchenBatch?> findById({
    required String restaurantId,
    required String batchId,
  }) async {
    final batch = _store.batches[batchId];
    if (batch == null || batch.restaurantId != restaurantId) return null;
    return batch;
  }

  @override
  Future<List<KitchenBatch>> listKitchenQueue({
    required String restaurantId,
    DateTime? since,
  }) async {
    return _store.batches.values
        .where((b) {
          if (b.restaurantId != restaurantId) return false;
          if (since != null && b.confirmedAt.isBefore(since)) return false;
          return true;
        })
        .toList()
      ..sort((a, b) => a.confirmedAt.compareTo(b.confirmedAt));
  }

  @override
  Future<List<BatchItem>> getItemsByBatchId(String batchId) async {
    return List.unmodifiable(_store.batchItemsByBatchId[batchId] ?? []);
  }

  @override
  Future<BatchItem> createItem(BatchItem item) async {
    _store.batchItemsByBatchId.putIfAbsent(item.batchId, () => []).add(item);
    return item;
  }

  @override
  Future<BatchItem> updateItemStatus(BatchItem item) async {
    final items = _store.batchItemsByBatchId[item.batchId];
    if (items == null) return item;
    final index = items.indexWhere((i) => i.id == item.id);
    if (index >= 0) items[index] = item;
    return item;
  }

  @override
  Future<List<BatchItemCustomization>> getCustomizationsByItemId(
    String batchItemId,
  ) async {
    return List.unmodifiable(
      _store.customizationsByBatchItemId[batchItemId] ?? [],
    );
  }

  @override
  Future<void> createCustomizations(
    List<BatchItemCustomization> customizations,
  ) async {
    for (final c in customizations) {
      _store.customizationsByBatchItemId
          .putIfAbsent(c.batchItemId, () => [])
          .add(c);
    }
  }

  @override
  Future<BatchItemStatusHistory> recordStatusHistory(
    BatchItemStatusHistory history,
  ) async {
    return history;
  }

  @override
  Future<int> nextBatchNumber({
    required String restaurantId,
    String? sessionId,
    String? orderId,
  }) async {
    if (sessionId != null) {
      final existing = _store.batchesForSession(sessionId);
      if (existing.isEmpty) return 1;
      return existing.map((b) => b.batchNumber).reduce((a, b) => a > b ? a : b) +
          1;
    }
    return 1;
  }
}
