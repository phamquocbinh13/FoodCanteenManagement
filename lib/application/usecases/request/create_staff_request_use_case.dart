import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../domain/entities/staff_request.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/request_repository.dart';
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
    required SessionEngineDataSource sessionDataSource,
    required SessionTimelineRecorder timelineRecorder,
    required MarkWaitingPaymentUseCase markWaitingPayment,
    required RequestDomainService domainService,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    required Clock clock,
  })  : _requestRepository = requestRepository,
        _sessionDataSource = sessionDataSource,
        _timeline = timelineRecorder,
        _markWaitingPayment = markWaitingPayment,
        _domain = domainService,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _clock = clock;

  final RequestRepository _requestRepository;
  final SessionEngineDataSource _sessionDataSource;
  final SessionTimelineRecorder _timeline;
  final MarkWaitingPaymentUseCase _markWaitingPayment;
  final RequestDomainService _domain;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final Clock _clock;

  @override
  Future<Result<StaffRequest>> call(CreateStaffRequestParams params) async {
    final session = _sessionDataSource.getSession(params.sessionId);
    if (session == null) {
      return const Err(
        NotFoundFailure('Session not found', code: 'SESSION_NOT_FOUND'),
      );
    }
    if (session.restaurantId != params.restaurantId) {
      return const Err(
        ValidationFailure('Session restaurant mismatch', code: 'RESTAURANT_MISMATCH'),
      );
    }

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

    _sessionDataSource.appendTimeline(
      _timeline.staffRequestCreated(
        sessionId: params.sessionId,
        requestId: saved.id,
        requestType: saved.requestType,
        actorId: params.deviceId,
      ),
    );

    await _eventPublisher.publish(
      StaffRequestCreated(
        eventId: _idGenerator.nextId(),
        occurredAt: now,
        aggregateId: saved.id,
        sessionId: params.sessionId,
        requestType: saved.requestType.name,
      ),
    );

    if (_domain.triggersPaymentPending(params.requestType) &&
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
