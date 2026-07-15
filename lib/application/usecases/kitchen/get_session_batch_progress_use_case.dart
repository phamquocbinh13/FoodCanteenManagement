import '../../../core/network/api_client.dart';
import '../../../core/network/http_api_client.dart';
import '../../../core/network/session_token_headers.dart';
import '../../../core/result/result.dart';
import '../../../data/datasources/customer/customer_session_local_datasource.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/services/kitchen_domain_service.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../kitchen/kitchen_view_models.dart';
import '../use_case.dart';

/// Customer batch-level progress (no item-level kitchen detail).
final class GetSessionBatchProgressUseCase
    implements
        UseCase<List<CustomerBatchProgressView>, GetSessionBatchProgressParams> {
  GetSessionBatchProgressUseCase({
    required BatchRepository batchRepository,
    KitchenDomainService? kitchenDomainService,
    ApiClient? apiClient,
    CustomerSessionLocalDataSource? localSession,
    this.preferCustomerProgressApi = false,
  })  : _batchRepository = batchRepository,
        _kitchenService = kitchenDomainService ?? const KitchenDomainService(),
        _api = apiClient,
        _localSession = localSession;

  final BatchRepository _batchRepository;
  final KitchenDomainService _kitchenService;
  final ApiClient? _api;
  final CustomerSessionLocalDataSource? _localSession;

  /// When true, uses `GET /sessions/me/batches/progress` (session token).
  final bool preferCustomerProgressApi;

  @override
  Future<Result<List<CustomerBatchProgressView>>> call(
    GetSessionBatchProgressParams params,
  ) async {
    if (preferCustomerProgressApi) {
      final remote = await _loadCustomerProgress();
      if (remote != null) return Success(remote);
    }

    try {
      final batches = await _batchRepository.listBySession(
        restaurantId: params.restaurantId,
        sessionId: params.sessionId,
      );
      final views = <CustomerBatchProgressView>[];

      for (final batch in batches) {
        final items = await _batchRepository.getItemsByBatchId(batch.id);
        final completed = _kitchenService.isBatchKitchenComplete(items);
        views.add(
          CustomerBatchProgressView(
            batchNumber: batch.batchNumber,
            statusLabel: completed ? 'Ready' : 'Preparing',
            isCompleted: completed,
            items: items.map((i) => KitchenBatchItemViewModel(
              id: i.id,
              name: i.menuItemNameSnapshot,
              quantityLabel: '${i.quantity.value}x',
              kitchenNotes: i.kitchenNotesRendered,
              status: i.status,
              lineTotalMinor: i.lineTotal.amountMinor,
            )).toList(),
          ),
        );
      }

      return Success(views);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  Future<List<CustomerBatchProgressView>?> _loadCustomerProgress() async {
    final api = _api;
    final local = _localSession;
    if (api == null || local == null) return null;

    final headers = await customerSessionHeaders(local);
    if (headers.isEmpty) return null;

    try {
      final response = await api.send<Map<String, dynamic>>(
        ApiRequest(
          path: '/sessions/me/batches/progress',
          requiresAuth: false,
          headers: headers,
        ),
      );
      final rows = (response.data['progress'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return [
        for (final row in rows)
          CustomerBatchProgressView(
            batchNumber: (row['batchNumber'] as num).toInt(),
            statusLabel: row['statusLabel'] as String? ?? 'Preparing',
            isCompleted: row['isCompleted'] as bool? ?? false,
            items: ((row['items'] as List<dynamic>?) ?? []).map((i) => KitchenBatchItemViewModel(
              id: i['id'] as String,
              name: i['menuItemNameSnapshot'] as String,
              quantityLabel: '${i['quantity']}x',
              kitchenNotes: i['kitchenNotesRendered'] as String? ?? '',
              status: _parseItemStatus(i['status'] as String?),
              lineTotalMinor: (i['lineTotal']?['amountMinor'] as num?)?.toInt() ?? 0,
            )).toList(),
          ),
      ];
    } catch (_) {
      return null;
    }
  }

  BatchItemStatus _parseItemStatus(String? status) {
    if (status == 'completed') return BatchItemStatus.completed;
    return BatchItemStatus.preparing;
  }
}

final class GetSessionBatchProgressParams {
  const GetSessionBatchProgressParams({
    required this.sessionId,
    required this.restaurantId,
  });

  final String sessionId;
  final String restaurantId;
}

/// Cashier read-only batch summaries for active session.
final class GetCashierBatchSummariesUseCase
    implements
        UseCase<List<CashierBatchSummaryView>, GetCashierBatchSummariesParams> {
  GetCashierBatchSummariesUseCase({
    required BatchRepository batchRepository,
    KitchenDomainService? kitchenDomainService,
  })  : _batchRepository = batchRepository,
        _kitchenService = kitchenDomainService ?? const KitchenDomainService();

  final BatchRepository _batchRepository;
  final KitchenDomainService _kitchenService;

  @override
  Future<Result<List<CashierBatchSummaryView>>> call(
    GetCashierBatchSummariesParams params,
  ) async {
    final batches = await _batchRepository.listBySession(
      restaurantId: params.restaurantId,
      sessionId: params.sessionId,
    );
    final views = <CashierBatchSummaryView>[];

    for (final batch in batches) {
      final items = await _batchRepository.getItemsByBatchId(batch.id);
      final completed = _kitchenService.isBatchKitchenComplete(items);
      final completedAt = await _batchRepository.getBatchCompletedAt(batch.id);
      views.add(
        CashierBatchSummaryView(
          batchId: batch.id,
          batchNumber: batch.batchNumber,
          statusLabel: completed ? 'Completed' : 'In kitchen',
          createdAt: batch.confirmedAt,
          items: items.map((i) => KitchenBatchItemViewModel(
            id: i.id,
            name: i.menuItemNameSnapshot,
            quantityLabel: '${i.quantity.value}x',
            kitchenNotes: i.kitchenNotesRendered,
            status: i.status,
          )).toList(),
          completedAt: completedAt,
        ),
      );
    }

    return Success(views);
  }
}

final class GetCashierBatchSummariesParams {
  const GetCashierBatchSummariesParams({
    required this.sessionId,
    required this.restaurantId,
  });

  final String sessionId;
  final String restaurantId;
}
