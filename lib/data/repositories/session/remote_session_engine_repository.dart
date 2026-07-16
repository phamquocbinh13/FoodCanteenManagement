import '../../../application/session/session_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/session_token_headers.dart';
import '../../../core/result/result.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../domain/entities/dine_in_session.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/entities/session_timeline_event.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../datasources/customer/customer_session_local_datasource.dart';

/// [SessionEngineRepository] backed by NestJS Session APIs (Stage A).
final class RemoteSessionEngineRepository implements SessionEngineRepository {
  RemoteSessionEngineRepository({
    required ApiClient apiClient,
    required CustomerSessionLocalDataSource localSession,
  })  : _api = apiClient,
        _localSession = localSession;

  final ApiClient _api;
  final CustomerSessionLocalDataSource _localSession;

  SessionEngineSnapshot _parseSnapshot(Map<String, dynamic> json) {
    return RemoteJson.parse(json, SessionEngineSnapshot.fromJson);
  }

  @override
  Future<Result<SessionAccess>> create({
    required String restaurantId,
    required String tableId,
    required SessionOpenedVia openedVia,
    String? openedByUserId,
    required String displayNumber,
    required int sessionSequence,
    required String sessionTokenValue,
    required DateTime tokenExpiresAt,
    required DateTime now,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/sessions',
          method: HttpMethod.post,
          body: {
            'tableId': tableId,
            'openedVia': _openedVia(openedVia),
            'displayNumber': displayNumber,
            'sessionSequence': sessionSequence,
            'sessionToken': sessionTokenValue,
            'tokenExpiresAt': tokenExpiresAt.toUtc().toIso8601String(),
          },
        ),
      );
      final data = response.data;
      final snapshot = _parseSnapshot(
        data['snapshot'] as Map<String, dynamic>,
      );
      final token = data['sessionToken'] as String? ?? sessionTokenValue;
      return Success(SessionAccess(snapshot: snapshot, sessionTokenValue: token));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> join({
    required String sessionTokenValue,
    required DateTime now,
    String? deviceId,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/join',
          method: HttpMethod.post,
          requiresAuth: false,
          body: {
            'sessionToken': sessionTokenValue,
            'deviceId': ?deviceId,
          },
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> close({
    required String sessionId,
    required String restaurantId,
    String? closedByUserId,
    required DateTime now,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/sessions/$sessionId/close',
          method: HttpMethod.post,
          body: {
            'closedByUserId': ?closedByUserId,
          },
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> markWaitingPayment({
    required String sessionId,
    required String restaurantId,
    required DateTime now,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/$restaurantId/sessions/$sessionId/waiting-payment',
          method: HttpMethod.post,
          body: const {},
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> transfer({
    required String sessionId,
    required String restaurantId,
    required String targetTableId,
    required DateTime now,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/sessions/$sessionId/transfer',
          method: HttpMethod.post,
          body: {'targetTableId': targetTableId},
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      final failure = failureFromException(e);
      if (failure.code == SessionErrorCodes.transferUnsupported ||
          failure.code == 'SESSION_TRANSFER_UNSUPPORTED') {
        return Err(
          ValidationFailure(
            SessionErrorMessages.transferUnsupported,
            code: SessionErrorCodes.transferUnsupported,
          ),
        );
      }
      return Err(failure);
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> findByToken(String sessionTokenValue) {
    return validateToken(sessionTokenValue);
  }

  @override
  Future<Result<SessionEngineSnapshot>> findById({
    required String sessionId,
    required String restaurantId,
  }) async {
    // Customer path: session token → GET /sessions/me (no staff JWT).
    final customerHeaders = await customerSessionHeaders(_localSession);
    if (customerHeaders.isNotEmpty) {
      try {
        final me = await _api.send<Map<String, dynamic>>(
          ApiRequest(
            path: '/sessions/me',
            requiresAuth: false,
            headers: customerHeaders,
          ),
        );
        final snapshot = _parseSnapshot(me.data);
        if (snapshot.session.id == sessionId &&
            snapshot.session.restaurantId == restaurantId) {
          return Success(snapshot);
        }
      } catch (_) {
        // Fall through to staff restaurant session lookup.
      }
    }

    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/sessions/$sessionId',
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot?>> findActiveByTable({
    required String restaurantId,
    required String tableId,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/tables/$tableId/session',
        ),
      );
      final sessionJson = response.data['session'];
      if (sessionJson == null) return const Success(null);
      return Success(_parseSnapshot(sessionJson as Map<String, dynamic>));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<List<SessionEngineSnapshot>>> restoreActiveSessions(
    String restaurantId,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/sessions/active'),
      );
      final items = (response.data['items'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_parseSnapshot)
          .toList();
      return Success(items);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> update(DineInSession session) async {
    try {
      final summary = session.paymentSummary;
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${session.restaurantId}/sessions/${session.id}',
          method: HttpMethod.patch,
          body: {
            'status': _status(session.status),
            'paymentStatus': _paymentStatus(session.paymentStatus),
            'currentBatchNumber': session.currentBatchNumber,
            'paymentSoftLock': session.paymentSoftLock,
            if (summary != null)
              'paymentSummary': {
                'subtotalMinor': summary.subtotalMinor,
                'discountMinor': summary.discountMinor,
                'taxMinor': summary.taxMinor,
                'serviceChargeMinor': summary.serviceChargeMinor,
                'totalMinor': summary.totalMinor,
              },
          },
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<int>> nextBatchNumber({
    required String sessionId,
    required String restaurantId,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/$restaurantId/sessions/$sessionId/next-batch-number',
          method: HttpMethod.post,
          body: const {},
        ),
      );
      return Success(response.data['nextBatchNumber'] as int);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<int>> nextDailySequence({
    required String restaurantId,
    required String dateKey,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/sessions/next-daily-sequence',
          queryParameters: {'dateKey': dateKey},
        ),
      );
      return Success(response.data['nextSequence'] as int);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<void>> appendTimeline(
    SessionTimelineEvent event, {
    String? restaurantId,
  }) async {
    final rid = restaurantId;
    if (rid == null || rid.isEmpty) {
      return const Err(
        ValidationFailure(
          'restaurantId required for remote timeline append',
          code: 'RESTAURANT_ID_REQUIRED',
        ),
      );
    }
    try {
      await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$rid/sessions/${event.sessionId}/timeline',
          method: HttpMethod.post,
          body: {
            'id': event.id,
            'eventType': _timelineType(event.eventType),
            'payloadJson': event.payloadJson,
            'actorType': _actorType(event.actorType),
            if (event.actorId != null) 'actorId': event.actorId,
            'occurredAt': event.occurredAt.toUtc().toIso8601String(),
          },
        ),
      );
      return const Success(null);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<SessionEngineSnapshot>> validateToken(
    String sessionTokenValue,
  ) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me',
          requiresAuth: false,
          headers: {
            'Authorization': 'Bearer $sessionTokenValue',
            'X-Session-Token': sessionTokenValue,
          },
        ),
      );
      return Success(_parseSnapshot(response.data));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  String _openedVia(SessionOpenedVia value) => switch (value) {
        SessionOpenedVia.qrScan => 'qr_scan',
        SessionOpenedVia.cashierManual => 'cashier_manual',
      };

  String _status(SessionStatus value) => switch (value) {
        SessionStatus.open => 'open',
        SessionStatus.paymentPending => 'payment_pending',
        SessionStatus.closed => 'closed',
      };

  String _paymentStatus(SessionPaymentStatus value) => switch (value) {
        SessionPaymentStatus.unpaid => 'unpaid',
        SessionPaymentStatus.waitingPayment => 'waiting_payment',
        SessionPaymentStatus.waitingGateway => 'waiting_gateway',
        SessionPaymentStatus.paid => 'paid',
      };

  String _actorType(ActorType value) => switch (value) {
        ActorType.user => 'user',
        ActorType.customerSession => 'customer_session',
        ActorType.system => 'system',
      };

  String _timelineType(SessionTimelineEventType value) => switch (value) {
        SessionTimelineEventType.sessionOpened => 'session_opened',
        SessionTimelineEventType.deviceJoined => 'device_joined',
        SessionTimelineEventType.cartItemAdded => 'cart_item_added',
        SessionTimelineEventType.cartItemRemoved => 'cart_item_removed',
        SessionTimelineEventType.batchConfirmed => 'batch_confirmed',
        SessionTimelineEventType.batchItemCompleted => 'batch_item_completed',
        SessionTimelineEventType.batchCompleted => 'batch_completed',
        SessionTimelineEventType.staffRequestCreated => 'staff_request_created',
        SessionTimelineEventType.staffRequestHandled => 'staff_request_handled',
        SessionTimelineEventType.paymentRequested => 'payment_requested',
        SessionTimelineEventType.paymentClosed => 'payment_closed',
        SessionTimelineEventType.sessionForceClosed => 'session_force_closed',
      };
}
