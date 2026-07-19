import '../../core/result/result.dart';
import '../entities/analytics_metrics.dart';
import '../entities/audit_log.dart';

abstract interface class AnalyticsRepository {
  Future<Result<ProductVelocityData>> getProductVelocity(String restaurantId);
  
  Future<Result<PredictiveInsightsData>> getPredictiveInsights(String restaurantId);
  
  Future<Result<List<AuditLog>>> getRecentAuditLogs(String restaurantId);

  Future<Result<List<RevenuePoint>>> getRevenue(String restaurantId);

  Future<Result<List<HeatmapPoint>>> getHeatmap(String restaurantId);

  Future<Result<KpiMetrics>> getKpis(String restaurantId);
}
