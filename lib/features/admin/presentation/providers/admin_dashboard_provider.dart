import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../cashier/presentation/providers/cashier_session_provider.dart';
import '../../../kitchen/presentation/providers/kitchen_provider.dart';
import '../../../request_queue/presentation/providers/request_queue_provider.dart';
import '../../../../application/request/staff_request_view_models.dart';
import '../../../../domain/entities/analytics_metrics.dart';
import '../../../../domain/entities/audit_log.dart';
import '../../../../domain/repositories/analytics_repository.dart';
import '../../../../domain/entities/staff_user.dart';
import '../../../../domain/entities/role.dart';
import '../../../../domain/entities/restaurant_settings.dart';
import '../../../../data/repositories/user/remote_user_repository.dart';
import '../../../../data/repositories/restaurant/remote_restaurant_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../app/config/restaurant_context.dart';
import 'package:get_it/get_it.dart';

final adminOpenTablesProvider = Provider<String>((ref) {
  final sessionState = ref.watch(cashierSessionControllerProvider);
  if (sessionState.isLoading && sessionState.tables.isEmpty) return '...';
  final total = sessionState.tables.length;
  final occupied = sessionState.occupiedTableCount;
  final open = total - occupied;
  return '$open/$total';
});

final adminRevenueProvider = Provider<String>((ref) {
  final sessionState = ref.watch(cashierSessionControllerProvider);
  if (sessionState.isLoading && sessionState.activeSessions.isEmpty) return '...';
  
  double total = 0.0;
  for (final snapshot in sessionState.activeSessions) {
    if (snapshot.session.paymentSummary != null) {
      total += snapshot.session.paymentSummary!.totalMinor / 100.0;
    }
  }
  return '\$${total.toStringAsFixed(2)}';
});

final adminNetProfitProvider = Provider<String>((ref) {
  return 'TBD';
});

final adminKitchenLoadCountProvider = Provider<int>((ref) {
  final kitchenState = ref.watch(kitchenControllerProvider);
  final queue = kitchenState.queue;
  if (queue == null) return 0;
  
  int pendingCount = 0;
  for (final batch in queue.batches) {
    if (batch.isActive) {
      for (final item in batch.items) {
        if (!item.isCompleted) pendingCount++;
      }
    }
  }
  return pendingCount;
});

final adminKitchenLoadProvider = Provider<String>((ref) {
  final count = ref.watch(adminKitchenLoadCountProvider);
  return '$count Items in Queue';
});

final adminSystemAlertProvider = Provider<StaffRequestQueueItemView?>((ref) {
  final queueState = ref.watch(requestQueueControllerProvider);
  if (queueState.items.isEmpty) return null;
  return queueState.items.first;
});

// --- Phase 2 Analytics Providers ---

final adminAnalyticsRepoProvider = Provider<AnalyticsRepository>((ref) {
  return GetIt.I<AnalyticsRepository>();
});

final adminVelocityProvider = FutureProvider.autoDispose<ProductVelocityData>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getProductVelocity();
  return result.valueOrNull ?? const ProductVelocityData();
});

final adminInsightsProvider = FutureProvider.autoDispose<PredictiveInsightsData>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getPredictiveInsights();
  return result.valueOrNull ?? const PredictiveInsightsData();
});

final adminAuditFeedProvider = FutureProvider.autoDispose<List<AuditLog>>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getRecentAuditLogs();
  return result.valueOrNull ?? [];
});

// --- Phase 4 Analytics Providers ---

final adminRevenueHistoryProvider = FutureProvider.autoDispose<List<RevenuePoint>>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getRevenue();
  return result.valueOrNull ?? [];
});

final adminHeatmapProvider = FutureProvider.autoDispose<List<HeatmapPoint>>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getHeatmap();
  return result.valueOrNull ?? [];
});

final adminKpisProvider = FutureProvider.autoDispose<KpiMetrics>((ref) async {
  final repo = ref.watch(adminAnalyticsRepoProvider);
  final result = await repo.getKpis();
  return result.valueOrNull ?? const KpiMetrics(averageOrderValueMinor: 0, totalSessions: 0, totalRevenueMinor: 0, paymentMethods: []);
});

enum HealthStatus { good, medium, critical }

final adminHealthStatusProvider = Provider<HealthStatus>((ref) {
  final count = ref.watch(adminKitchenLoadCountProvider);
  if (count >= 10) return HealthStatus.critical;
  if (count >= 5) return HealthStatus.medium;
  return HealthStatus.good;
});

// --- Phase 5 & 6 Repositories & Providers ---

final adminUserRepoProvider = Provider<RemoteUserRepository>((ref) {
  return RemoteUserRepository(GetIt.I<ApiClient>());
});

final adminSettingsRepoProvider = Provider<RemoteRestaurantRepository>((ref) {
  return RemoteRestaurantRepository(GetIt.I<ApiClient>());
});

final adminStaffListProvider = FutureProvider.autoDispose<List<StaffUser>>((ref) async {
  final repo = ref.watch(adminUserRepoProvider);
  final restaurantId = GetIt.I<RestaurantContext>().restaurantId;
  return repo.getAllStaff(restaurantId);
});

final adminRolesListProvider = FutureProvider.autoDispose<List<Role>>((ref) async {
  final repo = ref.watch(adminUserRepoProvider);
  return repo.getAllRoles();
});

final adminSettingsProvider = FutureProvider.autoDispose<RestaurantSettings?>((ref) async {
  final repo = ref.watch(adminSettingsRepoProvider);
  final restaurantId = GetIt.I<RestaurantContext>().restaurantId;
  return repo.getSettings(restaurantId);
});
