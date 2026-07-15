import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../data/repositories/batch/remote_batch_repository.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../kitchen/kitchen_view_models.dart';
import '../use_case.dart';

/// Loads FIFO kitchen queue from [BatchRepository.listKitchenQueue].
final class GetKitchenQueueUseCase
    implements UseCase<KitchenQueueView, GetKitchenQueueParams> {
  GetKitchenQueueUseCase({
    required BatchRepository batchRepository,
    required SessionEngineRepository sessionEngineRepository,
    required KitchenDomainService kitchenDomainService,
    required Clock clock,
  })  : _batchRepository = batchRepository,
        _sessionEngine = sessionEngineRepository,
        _kitchenService = kitchenDomainService,
        _clock = clock;

  final BatchRepository _batchRepository;
  final SessionEngineRepository _sessionEngine;
  final KitchenDomainService _kitchenService;
  final Clock _clock;

  @override
  Future<Result<KitchenQueueView>> call(GetKitchenQueueParams params) async {
    final batches = await _batchRepository.listKitchenQueue(
      restaurantId: params.restaurantId,
    );

    final remote = _batchRepository is RemoteBatchRepository
        ? _batchRepository
        : null;

    final views = <KitchenBatchViewModel>[];
    for (final batch in batches) {
      if (!_kitchenService.isKitchenSafeBatch(batch)) continue;

      final items = await _batchRepository.getItemsByBatchId(batch.id);
      final completedAt = await _batchRepository.getBatchCompletedAt(batch.id);
      final isComplete = _kitchenService.isBatchKitchenComplete(items);

      if (!params.showCompleted && isComplete) continue;

      var displayNumber = '—';
      var tableLabel = '—';
      final hints = remote?.queuePresentation(batch.id);
      if (hints != null) {
        displayNumber = hints.sessionDisplayNumber;
        tableLabel = hints.tableLabel;
      } else if (batch.sessionId != null) {
        final sessionResult = await _sessionEngine.findById(
          sessionId: batch.sessionId!,
          restaurantId: params.restaurantId,
        );
        if (sessionResult is Success<SessionEngineSnapshot>) {
          displayNumber = sessionResult.value.session.displayNumber;
          tableLabel = sessionResult.value.tableLabel;
        }
      }

      views.add(
        KitchenBatchViewModel(
          batchId: batch.id,
          batchNumber: batch.batchNumber,
          sessionDisplayNumber: displayNumber,
          tableLabel: tableLabel,
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
