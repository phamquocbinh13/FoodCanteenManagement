import '../../core/result/result.dart';
import '../entities/analytics_metrics.dart';
import '../entities/audit_log.dart';

abstract interface class AnalyticsRepository {
  Future<Result<ProductVelocityData>> getProductVelocity();
  
  Future<Result<PredictiveInsightsData>> getPredictiveInsights();
  
  Future<Result<List<AuditLog>>> getRecentAuditLogs();

  Future<Result<List<RevenuePoint>>> getRevenue();

  Future<Result<List<HeatmapPoint>>> getHeatmap();

  Future<Result<KpiMetrics>> getKpis();
}
