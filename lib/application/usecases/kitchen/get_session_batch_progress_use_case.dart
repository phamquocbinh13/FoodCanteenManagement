import '../../../core/result/result.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../kitchen/kitchen_view_models.dart';
import '../use_case.dart';

/// Customer batch-level progress (no item-level kitchen detail).
final class GetSessionBatchProgressUseCase
    implements UseCase<List<CustomerBatchProgressView>, GetSessionBatchProgressParams> {
  GetSessionBatchProgressUseCase({
    required OrderingStore store,
    required BatchRepository batchRepository,
    KitchenDomainService? kitchenDomainService,
  })  : _store = store,
        _batchRepository = batchRepository,
        _kitchenService = kitchenDomainService ?? const KitchenDomainService();

  final OrderingStore _store;
  final BatchRepository _batchRepository;
  final KitchenDomainService _kitchenService;

  @override
  Future<Result<List<CustomerBatchProgressView>>> call(
    GetSessionBatchProgressParams params,
  ) async {
    final batches = _store.batchesForSession(params.sessionId);
    final views = <CustomerBatchProgressView>[];

    for (final batch in batches) {
      final items = await _batchRepository.getItemsByBatchId(batch.id);
      final completed = _kitchenService.isBatchKitchenComplete(items);
      views.add(
        CustomerBatchProgressView(
          batchNumber: batch.batchNumber,
          statusLabel: completed ? 'Đã hoàn thành' : 'Đang chuẩn bị',
          isCompleted: completed,
        ),
      );
    }

    return Success(views);
  }
}

final class GetSessionBatchProgressParams {
  const GetSessionBatchProgressParams({required this.sessionId});

  final String sessionId;
}

/// Cashier read-only batch summaries for active session.
final class GetCashierBatchSummariesUseCase
    implements UseCase<List<CashierBatchSummaryView>, GetCashierBatchSummariesParams> {
  GetCashierBatchSummariesUseCase({
    required OrderingStore store,
    required BatchRepository batchRepository,
    KitchenDomainService? kitchenDomainService,
  })  : _store = store,
        _batchRepository = batchRepository,
        _kitchenService = kitchenDomainService ?? const KitchenDomainService();

  final OrderingStore _store;
  final BatchRepository _batchRepository;
  final KitchenDomainService _kitchenService;

  @override
  Future<Result<List<CashierBatchSummaryView>>> call(
    GetCashierBatchSummariesParams params,
  ) async {
    final batches = _store.batchesForSession(params.sessionId);
    final views = <CashierBatchSummaryView>[];

    for (final batch in batches) {
      final items = await _batchRepository.getItemsByBatchId(batch.id);
      final completed = _kitchenService.isBatchKitchenComplete(items);
      final completedAt = await _batchRepository.getBatchCompletedAt(batch.id);
      views.add(
        CashierBatchSummaryView(
          batchNumber: batch.batchNumber,
          statusLabel: completed ? 'Completed' : 'In kitchen',
          createdAt: batch.confirmedAt,
          completedAt: completedAt,
        ),
      );
    }

    return Success(views);
  }
}

final class GetCashierBatchSummariesParams {
  const GetCashierBatchSummariesParams({required this.sessionId});

  final String sessionId;
}
