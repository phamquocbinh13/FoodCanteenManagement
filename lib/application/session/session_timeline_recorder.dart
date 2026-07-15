import '../../../core/clock/clock.dart';
import '../../../core/id/id_generator.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/enums/domain_enums.dart';

/// Records append-only timeline entries for session aggregate events.
final class SessionTimelineRecorder {
  SessionTimelineRecorder({
    required IdGenerator idGenerator,
    required Clock clock,
  })  : _idGenerator = idGenerator,
        _clock = clock;

  final IdGenerator _idGenerator;
  final Clock _clock;

  SessionTimelineEvent sessionCreated({
    required String sessionId,
    required String displayNumber,
    required String tableId,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.sessionOpened,
      actorType: ActorType.user,
      actorId: actorId,
      payload: {
        'displayNumber': displayNumber,
        'tableId': tableId,
      },
    );
  }

  SessionTimelineEvent customerJoined({
    required String sessionId,
    String? deviceId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.deviceJoined,
      actorType: ActorType.customerSession,
      actorId: deviceId,
      payload: deviceId == null ? {} : {'deviceId': deviceId},
    );
  }

  SessionTimelineEvent waitingPaymentEntered({
    required String sessionId,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.paymentRequested,
      actorType: ActorType.user,
      actorId: actorId,
      payload: const {'phase': 'waiting_payment'},
    );
  }

  SessionTimelineEvent sessionClosed({
    required String sessionId,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.paymentClosed,
      actorType: ActorType.user,
      actorId: actorId,
      payload: const {},
    );
  }

  SessionTimelineEvent batchCreated({
    required String sessionId,
    required int batchNumber,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.batchConfirmed,
      actorType: ActorType.user,
      actorId: actorId,
      payload: {'batchNumber': batchNumber},
    );
  }

  SessionTimelineEvent batchItemCompleted({
    required String sessionId,
    required int batchNumber,
    required String menuItemName,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.batchItemCompleted,
      actorType: ActorType.user,
      actorId: actorId,
      payload: {
        'batchNumber': batchNumber,
        'menuItemName': menuItemName,
      },
    );
  }

  SessionTimelineEvent batchCompleted({
    required String sessionId,
    required int batchNumber,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.batchCompleted,
      actorType: ActorType.user,
      actorId: actorId,
      payload: {'batchNumber': batchNumber},
    );
  }

  SessionTimelineEvent cartItemAdded({
    required String sessionId,
    required String menuItemId,
    required int quantity,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.cartItemAdded,
      actorType: ActorType.customerSession,
      actorId: actorId,
      payload: {'menuItemId': menuItemId, 'quantity': quantity},
    );
  }

  SessionTimelineEvent staffRequestCreated({
    required String sessionId,
    required String requestId,
    required RequestType requestType,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.staffRequestCreated,
      actorType: ActorType.customerSession,
      actorId: actorId,
      payload: {
        'requestId': requestId,
        'requestType': requestType.name,
      },
    );
  }

  SessionTimelineEvent staffRequestHandled({
    required String sessionId,
    required String requestId,
    required RequestType requestType,
    String? actorId,
  }) {
    return _event(
      sessionId: sessionId,
      eventType: SessionTimelineEventType.staffRequestHandled,
      actorType: ActorType.user,
      actorId: actorId,
      payload: {
        'requestId': requestId,
        'requestType': requestType.name,
      },
    );
  }

  SessionTimelineEvent _event({
    required String sessionId,
    required SessionTimelineEventType eventType,
    required ActorType actorType,
    String? actorId,
    Map<String, dynamic> payload = const {},
  }) {
    return SessionTimelineEvent(
      id: _idGenerator.nextId(),
      sessionId: sessionId,
      eventType: eventType,
      payloadJson: payload,
      actorType: actorType,
      actorId: actorId,
      occurredAt: _clock.now(),
    );
  }
}

/// Mock token hash — production would use a secure one-way hash.
String hashSessionToken(String tokenValue) => 'hash_$tokenValue';
