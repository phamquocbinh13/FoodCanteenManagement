import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/session_token_headers.dart';
import '../../../core/result/result.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../data/mappers/remote_json.dart';
import '../../../data/repositories/batch/remote_batch_repository.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/events/domain_events.dart';
import '../../menu/kitchen_batch_ticket.dart';
import '../use_case.dart';
import 'confirm_batch_params.dart';

/// Remote ConfirmBatch: single `POST /sessions/me/batches` (server-owned).
final class ServerConfirmBatchUseCase
    implements UseCase<KitchenBatchTicket, ConfirmBatchParams> {
  ServerConfirmBatchUseCase({
    required ApiClient apiClient,
    required CustomerSessionLocalDataSource localSession,
    required DomainEventPublisher eventPublisher,
    required IdGenerator idGenerator,
    required Clock clock,
    RemoteBatchRepository? batchCache,
  })  : _api = apiClient,
        _localSession = localSession,
        _eventPublisher = eventPublisher,
        _idGenerator = idGenerator,
        _clock = clock,
        _batchCache = batchCache;

  final ApiClient _api;
  final CustomerSessionLocalDataSource _localSession;
  final DomainEventPublisher _eventPublisher;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final RemoteBatchRepository? _batchCache;

  @override
  Future<Result<KitchenBatchTicket>> call(ConfirmBatchParams params) async {
    try {
      final headers = await customerSessionHeaders(_localSession);
      if (headers.isEmpty) {
        return const Err(
          UnauthorizedFailure(
            'Customer session token required',
            code: 'SESSION_TOKEN_REQUIRED',
          ),
        );
      }

      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me/batches',
          method: HttpMethod.post,
          requiresAuth: false,
          headers: headers,
          body: const <String, dynamic>{},
        ),
      );

      final data = response.data;
      final batch = RemoteJson.parse(
        data['batch'] as Map<String, dynamic>,
        KitchenBatch.fromJson,
      );
      final items = RemoteJson.parseList(
        data['items'] as List<dynamic>? ?? const [],
        BatchItem.fromJson,
      );
      final tableLabel = data['tableLabel'] as String? ?? params.sessionId;

      final ticket = KitchenBatchTicket(
        batch: batch,
        tableLabel: tableLabel,
        items: items,
      );

      _batchCache?.cacheConfirmedBatch(batch: batch, items: items);

      await _eventPublisher.publish(
        BatchCreated(
          eventId: _idGenerator.nextId(),
          occurredAt: _clock.now(),
          aggregateId: batch.id,
          batchNumber: batch.batchNumber,
          sessionId: params.sessionId,
        ),
      );

      return Success(ticket);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
