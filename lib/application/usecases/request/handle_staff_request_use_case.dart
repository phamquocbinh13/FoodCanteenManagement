import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/request_domain_service.dart';
import '../../session/session_timeline_recorder.dart';
import '../use_case.dart';

/// Cashier marks a pending staff request as handled.
final class HandleStaffRequestUseCase
    implements UseCase<StaffRequest, HandleStaffRequestParams> {
  HandleStaffRequestUseCase({
    required RequestRepository requestRepository,
    required SessionEngineRepository sessionEngineRepository,
    required SessionTimelineRecorder timelineRecorder,
    required RequestDomainService domainService,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    required Clock clock,
  })  : _requestRepository = requestRepository,
        _sessionEngine = sessionEngineRepository,
        _timeline = timelineRecorder,
        _domain = domainService,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _clock = clock;

  final RequestRepository _requestRepository;
  final SessionEngineRepository _sessionEngine;
  final SessionTimelineRecorder _timeline;
  final RequestDomainService _domain;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final Clock _clock;

  @override
  Future<Result<StaffRequest>> call(HandleStaffRequestParams params) async {
    final existing = await _requestRepository.findById(params.requestId);
    if (existing == null) {
      return const Err(
        NotFoundFailure('Request not found', code: 'REQUEST_NOT_FOUND'),
      );
    }
    if (existing.restaurantId != params.restaurantId) {
      return const Err(
        ValidationFailure('Request restaurant mismatch', code: 'RESTAURANT_MISMATCH'),
      );
    }

    final now = _clock.now();
    final StaffRequest handled;
    try {
      handled = _domain.markHandled(
        request: existing,
        handledByUserId: params.handledByUserId,
        now: now,
      );
    } on RequestRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    final saved = await _requestRepository.update(handled);

    await _sessionEngine.appendTimeline(
      _timeline.staffRequestHandled(
        sessionId: saved.sessionId,
        requestId: saved.id,
        requestType: saved.requestType,
        actorId: params.handledByUserId,
      ),
      restaurantId: params.restaurantId,
    );

    await _eventPublisher.publish(
      StaffRequestHandled(
        eventId: _idGenerator.nextId(),
        occurredAt: now,
        aggregateId: saved.id,
        sessionId: saved.sessionId,
        handledByUserId: params.handledByUserId,
      ),
    );

    return Success(saved);
  }
}

final class HandleStaffRequestParams {
  const HandleStaffRequestParams({
    required this.restaurantId,
    required this.requestId,
    required this.handledByUserId,
  });

  final String restaurantId;
  final String requestId;
  final String handledByUserId;
}
