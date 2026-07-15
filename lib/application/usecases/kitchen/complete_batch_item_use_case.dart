import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/batch_item_status_history.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../session/session_timeline_recorder.dart';
import '../use_case.dart';

/// One tap → item completed. Auto-completes batch when all items are done.
final class CompleteBatchItemUseCase
    implements UseCase<void, CompleteBatchItemParams> {
  CompleteBatchItemUseCase({
    required BatchRepository batchRepository,
    required SessionEngineRepository sessionEngineRepository,
    required SessionTimelineRecorder timelineRecorder,
    required DomainEventPublisher eventPublisher,
    required IdGenerator idGenerator,
    required Clock clock,
    KitchenDomainService? kitchenDomainService,
  })  : _batchRepository = batchRepository,
        _sessionEngine = sessionEngineRepository,
        _timeline = timelineRecorder,
        _eventPublisher = eventPublisher,
        _idGenerator = idGenerator,
        _clock = clock,
        _kitchenService = kitchenDomainService ?? const KitchenDomainService();

  final BatchRepository _batchRepository;
  final SessionEngineRepository _sessionEngine;
  final SessionTimelineRecorder _timeline;
  final DomainEventPublisher _eventPublisher;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final KitchenDomainService _kitchenService;

  @override
  Future<Result<void>> call(CompleteBatchItemParams params) async {
    final existing = await _batchRepository.findItemById(
      restaurantId: params.restaurantId,
      batchItemId: params.batchItemId,
    );
    if (existing == null) {
      return const Err(NotFoundFailure('Batch item not found'));
    }

    if (existing.status == BatchItemStatus.completed ||
        existing.status == BatchItemStatus.served) {
      return const Success(null);
    }

    final now = _clock.now();
    BatchItem updated;
    try {
      updated = _kitchenService
          .validateAndTransitionItemStatus(
            item: existing,
            newStatus: BatchItemStatus.completed,
          )
          .copyWith(statusUpdatedAt: now);
    } on KitchenRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    await _batchRepository.updateItemStatus(updated);
    await _batchRepository.recordStatusHistory(
      BatchItemStatusHistory(
        id: _idGenerator.nextId(),
        batchItemId: updated.id,
        fromStatus: existing.status,
        toStatus: BatchItemStatus.completed,
        changedByUserId: params.actorId,
        occurredAt: now,
      ),
    );

    final batch = (await _batchRepository.findById(
      restaurantId: params.restaurantId,
      batchId: updated.batchId,
    ))!;

    await _eventPublisher.publish(
      BatchItemCompleted(
        eventId: _idGenerator.nextId(),
        occurredAt: now,
        aggregateId: updated.id,
        batchId: batch.id,
        batchItemId: updated.id,
      ),
    );

    if (batch.sessionId != null) {
      await _sessionEngine.appendTimeline(
        _timeline.batchItemCompleted(
          sessionId: batch.sessionId!,
          batchNumber: batch.batchNumber,
          menuItemName: updated.menuItemNameSnapshot,
          actorId: params.actorId,
        ),
        restaurantId: params.restaurantId,
      );
    }

    final allItems = await _batchRepository.getItemsByBatchId(batch.id);
    if (_kitchenService.isBatchKitchenComplete(allItems)) {
      final alreadyDone = await _batchRepository.getBatchCompletedAt(batch.id);
      if (alreadyDone == null) {
        await _batchRepository.markBatchCompleted(
          batchId: batch.id,
          completedAt: now,
        );

        if (batch.sessionId != null) {
          await _sessionEngine.appendTimeline(
            _timeline.batchCompleted(
              sessionId: batch.sessionId!,
              batchNumber: batch.batchNumber,
              actorId: params.actorId,
            ),
            restaurantId: params.restaurantId,
          );
        }

        await _eventPublisher.publish(
          BatchCompleted(
            eventId: _idGenerator.nextId(),
            occurredAt: now,
            aggregateId: batch.id,
            batchNumber: batch.batchNumber,
          ),
        );
      }
    }

    return const Success(null);
  }
}

final class CompleteBatchItemParams {
  const CompleteBatchItemParams({
    required this.restaurantId,
    required this.batchItemId,
    this.actorId,
  });

  final String restaurantId;
  final String batchItemId;
  final String? actorId;
}
