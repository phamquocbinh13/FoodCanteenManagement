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
  Future<Result<ProductVelocityData>> getProductVelocity() async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        const ApiRequest(path: '/analytics/velocity', method: HttpMethod.get),
      );
      return Success(ProductVelocityData.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load velocity'));
    }
  }

  @override
  Future<Result<PredictiveInsightsData>> getPredictiveInsights() async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        const ApiRequest(path: '/analytics/insights', method: HttpMethod.get),
      );
      return Success(PredictiveInsightsData.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load insights'));
    }
  }

  @override
  Future<Result<List<AuditLog>>> getRecentAuditLogs() async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        const ApiRequest(path: '/audit/recent', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => AuditLog.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load audit logs'));
    }
  }

  @override
  Future<Result<List<RevenuePoint>>> getRevenue() async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        const ApiRequest(path: '/analytics/revenue', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => RevenuePoint.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load revenue'));
    }
  }

  @override
  Future<Result<List<HeatmapPoint>>> getHeatmap() async {
    try {
      final response = await _apiClient.send<List<dynamic>>(
        const ApiRequest(path: '/analytics/heatmap', method: HttpMethod.get),
      );
      return Success(response.data.map((e) => HeatmapPoint.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      return Err(UnknownFailure('Failed to load heatmap'));
    }
  }

  @override
  Future<Result<KpiMetrics>> getKpis() async {
    try {
      final response = await _apiClient.send<Map<String, dynamic>>(
        const ApiRequest(path: '/analytics/kpis', method: HttpMethod.get),
      );
      return Success(KpiMetrics.fromJson(response.data));
    } catch (e) {
      return Err(UnknownFailure('Failed to load KPIs'));
    }
  }
}
