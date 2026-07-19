import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/analytics_metrics.dart';
import '../../../domain/entities/audit_log.dart';
import '../../../domain/repositories/analytics_repository.dart';

class RemoteAnalyticsRepository implements AnalyticsRepository {
  RemoteAnalyticsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<ProductVelocityData>> getProductVelocity(String restaurantId) async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/analytics/velocity', method: HttpMethod.get),
      );
      return Success(ProductVelocityData.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load velocity'));
    }
  }

  @override
  Future<Result<PredictiveInsightsData>> getPredictiveInsights(String restaurantId) async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/analytics/insights', method: HttpMethod.get),
      );
      return Success(PredictiveInsightsData.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load insights'));
    }
  }

  @override
  Future<Result<List<AuditLog>>> getRecentAuditLogs(String restaurantId) async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/audit/recent', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => AuditLog.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load audit logs'));
    }
  }

  @override
  Future<Result<List<RevenuePoint>>> getRevenue(String restaurantId) async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/analytics/revenue', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => RevenuePoint.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load revenue'));
    }
  }

  @override
  Future<Result<List<HeatmapPoint>>> getHeatmap(String restaurantId) async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/analytics/heatmap', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => HeatmapPoint.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load heatmap'));
    }
  }

  @override
  Future<Result<KpiMetrics>> getKpis(String restaurantId) async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        ApiRequest(path: '/restaurants/$restaurantId/analytics/kpis', method: HttpMethod.get),
      );
      return Success(KpiMetrics.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load KPIs'));
    }
  }
}
