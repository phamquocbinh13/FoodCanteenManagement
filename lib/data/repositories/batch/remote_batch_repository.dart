import '../../../application/session/session_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/json_key_codec.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/batch_item_customization.dart';
import '../../../domain/entities/batch_item_status_history.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/batch_repository.dart';

/// [BatchRepository] backed by NestJS Batch + Kitchen APIs.
///
/// Client-generated IDs from ConfirmBatch are aliased to server UUIDs so
/// subsequent createItem/createCustomizations calls resolve correctly.
final class RemoteBatchRepository implements BatchRepository {
  RemoteBatchRepository({
    required ApiClient apiClient,
    String defaultRestaurantId = SessionEngineConstants.demoRestaurantId,
  })  : _api = apiClient,
        _defaultRestaurantId = defaultRestaurantId;

  final ApiClient _api;
  final String _defaultRestaurantId;

  final Map<String, String> _clientToServerBatchId = {};
  final Map<String, String> _clientToServerItemId = {};
  final Map<String, KitchenBatch> _batches = {};
  final Map<String, List<BatchItem>> _itemsByBatchId = {};
  final Map<String, List<BatchItemCustomization>> _modsByItemId = {};
  final Map<String, DateTime?> _completedAtByBatchId = {};
  final Map<String, String> _restaurantIdByBatchId = {};

  String _serverBatchId(String id) => _clientToServerBatchId[id] ?? id;

  String _serverItemId(String id) => _clientToServerItemId[id] ?? id;

  KitchenBatch _parseBatch(Map<String, dynamic> json) {
    final snake = camelCaseKeysToSnake(json);
    final completedRaw = snake.remove('completed_at');
    final batch = KitchenBatch.fromJson(snake);
    if (completedRaw is String) {
      _completedAtByBatchId[batch.id] = DateTime.parse(completedRaw);
    } else if (completedRaw == null) {
      _completedAtByBatchId.putIfAbsent(batch.id, () => null);
    }
    _batches[batch.id] = batch;
    _restaurantIdByBatchId[batch.id] = batch.restaurantId;
    return batch;
  }

  BatchItem _parseItem(Map<String, dynamic> json) {
    final item = BatchItem.fromJson(camelCaseKeysToSnake(json));
    final list = _itemsByBatchId.putIfAbsent(item.batchId, () => []);
    final index = list.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      list[index] = item;
    } else {
      list.add(item);
    }
    return item;
  }

  void _cacheTicket({
    required Map<String, dynamic> batchJson,
    required List<dynamic> itemsJson,
    String? clientBatchId,
  }) {
    final serverBatch = _parseBatch(batchJson);
    if (clientBatchId != null && clientBatchId != serverBatch.id) {
      _clientToServerBatchId[clientBatchId] = serverBatch.id;
      _batches[clientBatchId] = serverBatch.copyWith(id: clientBatchId);
      _restaurantIdByBatchId[clientBatchId] = serverBatch.restaurantId;
      _itemsByBatchId[clientBatchId] = [];
      if (_completedAtByBatchId.containsKey(serverBatch.id)) {
        _completedAtByBatchId[clientBatchId] =
            _completedAtByBatchId[serverBatch.id];
      }
    }

    final items = itemsJson
        .cast<Map<String, dynamic>>()
        .map(_parseItem)
        .toList();
    _itemsByBatchId[serverBatch.id] = items;
    if (clientBatchId != null) {
      _itemsByBatchId[clientBatchId] = [
        for (final item in items)
          item.copyWith(batchId: clientBatchId),
      ];
    }
  }

  String _actorType(ActorType value) => switch (value) {
        ActorType.user => 'user',
        ActorType.customerSession => 'customer_session',
        ActorType.system => 'system',
      };

  @override
  Future<KitchenBatch> create(KitchenBatch batch) async {
    final sessionId = batch.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      throw StateError('Remote batch create requires sessionId');
    }
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/${batch.restaurantId}/sessions/$sessionId/batches',
          method: HttpMethod.post,
          body: {
            'batchNumber': batch.batchNumber,
            'confirmedByActorType': _actorType(batch.confirmedByActorType),
            if (batch.confirmedByActorId != null)
              'confirmedByActorId': batch.confirmedByActorId,
          },
        ),
      );
      final server = _parseBatch(response.data);
      _clientToServerBatchId[batch.id] = server.id;
      _batches[batch.id] = batch;
      _restaurantIdByBatchId[batch.id] = batch.restaurantId;
      _itemsByBatchId[batch.id] = [];
      _completedAtByBatchId[batch.id] = _completedAtByBatchId[server.id];
      return batch;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<KitchenBatch?> findById({
    required String restaurantId,
    required String batchId,
  }) async {
    final cached = _batches[batchId] ?? _batches[_serverBatchId(batchId)];
    if (cached != null && cached.restaurantId == restaurantId) {
      return _batches[batchId] ?? cached.copyWith(id: batchId);
    }
    try {
      final serverId = _serverBatchId(batchId);
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/batches/$serverId'),
      );
      _cacheTicket(
        batchJson: response.data['batch'] as Map<String, dynamic>,
        itemsJson: response.data['items'] as List<dynamic>? ?? const [],
        clientBatchId: batchId != serverId ? batchId : null,
      );
      return _batches[batchId] ?? _batches[serverId];
    } catch (e) {
      final failure = failureFromException(e);
      if (failure.code == 'BATCH_NOT_FOUND' || failure.code == 'NOT_FOUND') {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<KitchenBatch>> listKitchenQueue({
    required String restaurantId,
    DateTime? since,
  }) async {
    try {
      final queue = await _api.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/kitchen/queue'),
      );
      final views = (queue.data['batches'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final result = <KitchenBatch>[];
      for (final view in views) {
        final batchId = view['batchId'] as String;
        final ticket = await _api.send<Map<String, dynamic>>(
          ApiRequest(path: '/restaurants/$restaurantId/batches/$batchId'),
        );
        _cacheTicket(
          batchJson: ticket.data['batch'] as Map<String, dynamic>,
          itemsJson: ticket.data['items'] as List<dynamic>? ?? const [],
        );
        final batch = _batches[batchId];
        if (batch == null) continue;
        if (since != null && batch.confirmedAt.isBefore(since)) continue;
        if (view['completedAt'] is String) {
          _completedAtByBatchId[batchId] =
              DateTime.parse(view['completedAt'] as String);
        }
        result.add(batch);
      }
      result.sort((a, b) => a.confirmedAt.compareTo(b.confirmedAt));
      return result;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<List<KitchenBatch>> listBySession({
    required String restaurantId,
    required String sessionId,
  }) async {
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/$restaurantId/sessions/$sessionId/batches',
        ),
      );
      final tickets = (response.data['batches'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      final batches = <KitchenBatch>[];
      for (final ticket in tickets) {
        _cacheTicket(
          batchJson: ticket['batch'] as Map<String, dynamic>,
          itemsJson: ticket['items'] as List<dynamic>? ?? const [],
        );
        final batchJson = ticket['batch'] as Map<String, dynamic>;
        final id = batchJson['id'] as String? ??
            camelCaseKeysToSnake(batchJson)['id'] as String;
        final batch = _batches[id];
        if (batch != null) batches.add(batch);
      }
      batches.sort((a, b) => a.batchNumber.compareTo(b.batchNumber));
      return batches;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<List<BatchItem>> getItemsByBatchId(String batchId) async {
    final cached = _itemsByBatchId[batchId] ??
        _itemsByBatchId[_serverBatchId(batchId)];
    if (cached != null) return List.unmodifiable(cached);

    final restaurantId =
        _restaurantIdByBatchId[batchId] ?? _defaultRestaurantId;
    await findById(restaurantId: restaurantId, batchId: batchId);
    return List.unmodifiable(
      _itemsByBatchId[batchId] ??
          _itemsByBatchId[_serverBatchId(batchId)] ??
          const [],
    );
  }

  @override
  Future<BatchItem> createItem(BatchItem item) async {
    final serverBatchId = _serverBatchId(item.batchId);
    final restaurantId =
        _restaurantIdByBatchId[item.batchId] ?? _defaultRestaurantId;
    try {
      final response = await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/restaurants/$restaurantId/batches/$serverBatchId/items',
          method: HttpMethod.post,
          body: {
            'menuItemId': item.menuItemId,
            'menuItemNameSnapshot': item.menuItemNameSnapshot,
            'unitPriceMinor': item.unitPriceSnapshot.amountMinor,
            'currencyCode': item.unitPriceSnapshot.currencyCode,
            'quantity': item.quantity.value,
            'lineTotalMinor': item.lineTotal.amountMinor,
            'kitchenNotesRendered': item.kitchenNotesRendered,
          },
        ),
      );
      final server = _parseItem(response.data);
      _clientToServerItemId[item.id] = server.id;
      final local = item.copyWith(batchId: item.batchId);
      final list = _itemsByBatchId.putIfAbsent(item.batchId, () => []);
      list.add(local);
      return local;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<BatchItem> updateItemStatus(BatchItem item) async {
    if (item.status != BatchItemStatus.completed &&
        item.status != BatchItemStatus.served) {
      // Local-only status cache for non-complete transitions.
      final list = _itemsByBatchId[item.batchId] ??
          _itemsByBatchId[_serverBatchId(item.batchId)];
      if (list != null) {
        final index = list.indexWhere(
          (i) => i.id == item.id || i.id == _serverItemId(item.id),
        );
        if (index >= 0) list[index] = item;
      }
      return item;
    }

    final restaurantId =
        _restaurantIdByBatchId[item.batchId] ?? _defaultRestaurantId;
    final serverItemId = _serverItemId(item.id);
    try {
      await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/$restaurantId/kitchen/items/$serverItemId/complete',
          method: HttpMethod.post,
          body: const {},
        ),
      );
      final list = _itemsByBatchId.putIfAbsent(item.batchId, () => []);
      final index = list.indexWhere(
        (i) => i.id == item.id || i.id == serverItemId,
      );
      if (index >= 0) {
        list[index] = item;
      } else {
        list.add(item);
      }
      return item;
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<BatchItem?> findItemById({
    required String restaurantId,
    required String batchItemId,
  }) async {
    for (final entry in _itemsByBatchId.entries) {
      for (final item in entry.value) {
        if (item.id == batchItemId ||
            _serverItemId(item.id) == batchItemId ||
            item.id == _serverItemId(batchItemId)) {
          return item.copyWith(id: batchItemId);
        }
      }
    }

    // Refresh kitchen queue cache then retry.
    await listKitchenQueue(restaurantId: restaurantId);
    for (final entry in _itemsByBatchId.entries) {
      for (final item in entry.value) {
        if (item.id == batchItemId ||
            _serverItemId(batchItemId) == item.id) {
          return item;
        }
      }
    }
    return null;
  }

  @override
  Future<DateTime?> getBatchCompletedAt(String batchId) async {
    return _completedAtByBatchId[batchId] ??
        _completedAtByBatchId[_serverBatchId(batchId)];
  }

  @override
  Future<void> markBatchCompleted({
    required String batchId,
    required DateTime completedAt,
  }) async {
    // Kitchen complete endpoint marks the batch when all items are done.
    _completedAtByBatchId[batchId] = completedAt;
    final serverId = _serverBatchId(batchId);
    if (serverId != batchId) {
      _completedAtByBatchId[serverId] = completedAt;
    }
  }

  @override
  Future<List<BatchItemCustomization>> getCustomizationsByItemId(
    String batchItemId,
  ) async {
    return List.unmodifiable(
      _modsByItemId[batchItemId] ??
          _modsByItemId[_serverItemId(batchItemId)] ??
          const [],
    );
  }

  @override
  Future<void> createCustomizations(
    List<BatchItemCustomization> customizations,
  ) async {
    if (customizations.isEmpty) return;
    final clientItemId = customizations.first.batchItemId;
    final serverItemId = _serverItemId(clientItemId);
    final batchId = _itemsByBatchId.entries
        .where(
          (e) => e.value.any(
            (i) => i.id == clientItemId || i.id == serverItemId,
          ),
        )
        .map((e) => e.key)
        .firstOrNull;
    final restaurantId = batchId != null
        ? (_restaurantIdByBatchId[batchId] ?? _defaultRestaurantId)
        : _defaultRestaurantId;

    try {
      await _api.send<Map<String, dynamic>>(
        ApiRequest(
          path:
              '/restaurants/$restaurantId/batch-items/$serverItemId/customizations',
          method: HttpMethod.post,
          body: {
            'customizations': [
              for (final c in customizations)
                {
                  'groupKey': c.groupKey,
                  'groupNameSnapshot': c.groupNameSnapshot,
                  if (c.optionKey != null) 'optionKey': c.optionKey,
                  if (c.optionNameSnapshot != null)
                    'optionNameSnapshot': c.optionNameSnapshot,
                  'valueJson': c.valueJson,
                  'priceDeltaMinor': c.priceDeltaSnapshot.amountMinor,
                  'currencyCode': c.priceDeltaSnapshot.currencyCode,
                  'kitchenLabelRendered': c.kitchenLabelRendered,
                },
            ],
          },
        ),
      );
      _modsByItemId.putIfAbsent(clientItemId, () => []).addAll(customizations);
    } catch (e) {
      throw failureFromException(e);
    }
  }

  @override
  Future<BatchItemStatusHistory> recordStatusHistory(
    BatchItemStatusHistory history,
  ) async {
    // Backend records history inside kitchen complete.
    return history;
  }

  @override
  Future<int> nextBatchNumber({
    required String restaurantId,
    String? sessionId,
    String? orderId,
  }) async {
    if (sessionId == null) return 1;
    final batches = await listBySession(
      restaurantId: restaurantId,
      sessionId: sessionId,
    );
    if (batches.isEmpty) return 1;
    return batches.map((b) => b.batchNumber).reduce((a, b) => a > b ? a : b) +
        1;
  }
}
