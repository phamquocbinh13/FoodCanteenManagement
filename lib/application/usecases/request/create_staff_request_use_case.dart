import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/enums/domain_enums.dart'; // SessionStatus, RequestType
import '../../../domain/events/domain_events.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/request_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/request_domain_service.dart';
import '../../session/session_timeline_recorder.dart';
import '../session/mark_waiting_payment_use_case.dart';
import '../use_case.dart';

/// Customer creates a call-staff queue entry.
///
/// Payment requests also transition the session to waiting-for-payment.
final class CreateStaffRequestUseCase
    implements UseCase<StaffRequest, CreateStaffRequestParams> {
  CreateStaffRequestUseCase({
    required RequestRepository requestRepository,
    required SessionEngineRepository sessionEngineRepository,
    required SessionTimelineRecorder timelineRecorder,
    required MarkWaitingPaymentUseCase markWaitingPayment,
    required RequestDomainService domainService,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    required Clock clock,
    /// When true, server create already wrote timeline + payment transition.
    this.serverOwnsSideEffects = false,
  })  : _requestRepository = requestRepository,
        _sessionEngine = sessionEngineRepository,
        _timeline = timelineRecorder,
        _markWaitingPayment = markWaitingPayment,
        _domain = domainService,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _clock = clock;

  final RequestRepository _requestRepository;
  final SessionEngineRepository _sessionEngine;
  final SessionTimelineRecorder _timeline;
  final MarkWaitingPaymentUseCase _markWaitingPayment;
  final RequestDomainService _domain;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final Clock _clock;
  final bool serverOwnsSideEffects;

  @override
  Future<Result<StaffRequest>> call(CreateStaffRequestParams params) async {
    final sessionResult = await _sessionEngine.findById(
      sessionId: params.sessionId,
      restaurantId: params.restaurantId,
    );
    if (sessionResult is Err<SessionEngineSnapshot>) {
      return Err(sessionResult.failure);
    }
    if (sessionResult is! Success<SessionEngineSnapshot>) {
      return const Err(
        NotFoundFailure('Session not found', code: 'SESSION_NOT_FOUND'),
      );
    }
    final session = sessionResult.value.session;

    final existing = await _requestRepository.listBySessionId(params.sessionId);

    try {
      _domain.validateCanCreateRequest(
        session: session,
        requestType: params.requestType,
      );
      _domain.validateNoDuplicatePendingPayment(
        requestType: params.requestType,
        existingForSession: existing,
      );
    } on RequestRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    final now = _clock.now();
    final request = _domain.createRequest(
      id: _idGenerator.nextId(),
      restaurantId: params.restaurantId,
      sessionId: params.sessionId,
      requestType: params.requestType,
      now: now,
      note: params.note,
    );

    final saved = await _requestRepository.create(request);

    if (!serverOwnsSideEffects) {
      await _sessionEngine.appendTimeline(
        _timeline.staffRequestCreated(
          sessionId: params.sessionId,
          requestId: saved.id,
          requestType: saved.requestType,
          actorId: params.deviceId,
        ),
        restaurantId: params.restaurantId,
      );
    }

    await _eventPublisher.publish(
      StaffRequestCreated(
        eventId: _idGenerator.nextId(),
        occurredAt: now,
        aggregateId: saved.id,
        sessionId: params.sessionId,
        requestType: saved.requestType.name,
      ),
    );

    if (!serverOwnsSideEffects &&
        _domain.triggersPaymentPending(params.requestType) &&
        session.status != SessionStatus.paymentPending) {
      final paymentResult = await _markWaitingPayment(
        MarkWaitingPaymentParams(
          sessionId: params.sessionId,
          restaurantId: params.restaurantId,
        ),
      );
      final paymentFailure = paymentResult.failureOrNull;
      if (paymentFailure != null) {
        return Err(paymentFailure);
      }
    }

    return Success(saved);
  }
}

final class CreateStaffRequestParams {
  const CreateStaffRequestParams({
    required this.restaurantId,
    required this.sessionId,
    required this.requestType,
    this.note,
    this.deviceId,
  });

  final String restaurantId;
  final String sessionId;
  final RequestType requestType;
  final String? note;
  final String? deviceId;
}
