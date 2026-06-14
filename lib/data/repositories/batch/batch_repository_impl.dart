import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/batch_item_customization.dart';
import '../../../domain/entities/batch_item_status_history.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/repositories/batch_repository.dart';

final class BatchRepositoryImpl implements BatchRepository {
  Never _notImplemented(String method) =>
      throw UnimplementedError('BatchRepositoryImpl.$method');

  @override
  Future<KitchenBatch> create(KitchenBatch batch) => _notImplemented('create');

  @override
  Future<KitchenBatch?> findById({
    required String restaurantId,
    required String batchId,
  }) =>
      _notImplemented('findById');

  @override
  Future<List<KitchenBatch>> listKitchenQueue({
    required String restaurantId,
    DateTime? since,
  }) =>
      _notImplemented('listKitchenQueue');

  @override
  Future<List<BatchItem>> getItemsByBatchId(String batchId) =>
      _notImplemented('getItemsByBatchId');

  @override
  Future<BatchItem> createItem(BatchItem item) =>
      _notImplemented('createItem');

  @override
  Future<BatchItem> updateItemStatus(BatchItem item) =>
      _notImplemented('updateItemStatus');

  @override
  Future<List<BatchItemCustomization>> getCustomizationsByItemId(
    String batchItemId,
  ) =>
      _notImplemented('getCustomizationsByItemId');

  @override
  Future<void> createCustomizations(
    List<BatchItemCustomization> customizations,
  ) =>
      _notImplemented('createCustomizations');

  @override
  Future<BatchItemStatusHistory> recordStatusHistory(
    BatchItemStatusHistory history,
  ) =>
      _notImplemented('recordStatusHistory');

  @override
  Future<int> nextBatchNumber({
    required String restaurantId,
    String? sessionId,
    String? orderId,
  }) =>
      _notImplemented('nextBatchNumber');
}
