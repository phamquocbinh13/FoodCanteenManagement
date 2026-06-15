import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../kitchen/kitchen_view_models.dart';
import '../use_case.dart';

/// Loads FIFO kitchen queue from [BatchRepository.listKitchenQueue].
final class GetKitchenQueueUseCase
    implements UseCase<KitchenQueueView, GetKitchenQueueParams> {
  GetKitchenQueueUseCase({
    required BatchRepository batchRepository,
    required SessionEngineDataSource sessionDataSource,
    required KitchenDomainService kitchenDomainService,
    required Clock clock,
  })  : _batchRepository = batchRepository,
        _sessionDataSource = sessionDataSource,
        _kitchenService = kitchenDomainService,
        _clock = clock;

  final BatchRepository _batchRepository;
  final SessionEngineDataSource _sessionDataSource;
  final KitchenDomainService _kitchenService;
  final Clock _clock;

  @override
  Future<Result<KitchenQueueView>> call(GetKitchenQueueParams params) async {
    final batches = await _batchRepository.listKitchenQueue(
      restaurantId: params.restaurantId,
    );

    final views = <KitchenBatchViewModel>[];
    for (final batch in batches) {
      if (!_kitchenService.isKitchenSafeBatch(batch)) continue;

      final items = await _batchRepository.getItemsByBatchId(batch.id);
      final completedAt = await _batchRepository.getBatchCompletedAt(batch.id);
      final isComplete = _kitchenService.isBatchKitchenComplete(items);

      if (!params.showCompleted && isComplete) continue;

      final session = batch.sessionId == null
          ? null
          : _sessionDataSource.getSession(batch.sessionId!);
      final table = session == null
          ? null
          : _sessionDataSource.getTable(session.tableId);

      views.add(
        KitchenBatchViewModel(
          batchId: batch.id,
          batchNumber: batch.batchNumber,
          sessionDisplayNumber: session?.displayNumber ?? '—',
          tableLabel: _kitchenService.resolveTableLabel(
                batch: batch,
                table: table,
              ) ??
              '—',
          createdAt: batch.confirmedAt,
          completedAt: completedAt,
          status: isComplete
              ? KitchenBatchDisplayStatus.completed
              : KitchenBatchDisplayStatus.pending,
          items: items
              .map(
                (item) => KitchenBatchItemViewModel(
                  id: item.id,
                  name: item.menuItemNameSnapshot,
                  quantityLabel: item.quantity.value > 1
                      ? '×${item.quantity.value}'
                      : '',
                  kitchenNotes: item.kitchenNotesRendered,
                  status: item.status,
                ),
              )
              .toList(),
        ),
      );
    }

    return Success(
      KitchenQueueView(batches: views, loadedAt: _clock.now()),
    );
  }
}

final class GetKitchenQueueParams {
  const GetKitchenQueueParams({
    required this.restaurantId,
    this.showCompleted = false,
  });

  final String restaurantId;
  final bool showCompleted;
}
