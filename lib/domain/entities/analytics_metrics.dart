import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_metrics.freezed.dart';
part 'analytics_metrics.g.dart';

@freezed
abstract class ProductVelocity with _$ProductVelocity {
  const factory ProductVelocity({
    required String id,
    required String name,
    required int quantitySold,
    String? imageUrl,
    required String currencyCode,
    required int basePriceMinor,
  }) = _ProductVelocity;

  factory ProductVelocity.fromJson(Map<String, dynamic> json) =>
      _$ProductVelocityFromJson(json);
}

@freezed
abstract class ProductVelocityData with _$ProductVelocityData {
  const factory ProductVelocityData({
    @Default([]) List<ProductVelocity> bestSellers,
    @Default([]) List<ProductVelocity> worstSellers,
  }) = _ProductVelocityData;

  factory ProductVelocityData.fromJson(Map<String, dynamic> json) =>
      _$ProductVelocityDataFromJson(json);
}

@freezed
abstract class WeatherDay with _$WeatherDay {
  const factory WeatherDay({
    required String date,
    required int weatherCode,
    required int tempMax,
    required int tempMin,
  }) = _WeatherDay;

  factory WeatherDay.fromJson(Map<String, dynamic> json) =>
      _$WeatherDayFromJson(json);
}

@freezed
abstract class PredictiveInsightsData with _$PredictiveInsightsData {
  const factory PredictiveInsightsData({
    @Default([]) List<String> alerts,
    @Default([]) List<WeatherDay> forecastDays,
  }) = _PredictiveInsightsData;

  factory PredictiveInsightsData.fromJson(Map<String, dynamic> json) =>
      _$PredictiveInsightsDataFromJson(json);
}

@freezed
abstract class RevenuePoint with _$RevenuePoint {
  const factory RevenuePoint({
    required String date,
    required int revenueMinor,
  }) = _RevenuePoint;

  factory RevenuePoint.fromJson(Map<String, dynamic> json) =>
      _$RevenuePointFromJson(json);
}

@freezed
abstract class HeatmapPoint with _$HeatmapPoint {
  const factory HeatmapPoint({
    required int hour,
    required int intensity,
  }) = _HeatmapPoint;

  factory HeatmapPoint.fromJson(Map<String, dynamic> json) =>
      _$HeatmapPointFromJson(json);
}

@freezed
abstract class PaymentMethodSummary with _$PaymentMethodSummary {
  const factory PaymentMethodSummary({
    required String method,
    required int totalMinor,
  }) = _PaymentMethodSummary;

  factory PaymentMethodSummary.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodSummaryFromJson(json);
}

@freezed
abstract class KpiMetrics with _$KpiMetrics {
  const factory KpiMetrics({
    required int averageOrderValueMinor,
    required int totalSessions,
    required int totalRevenueMinor,
    @Default([]) List<PaymentMethodSummary> paymentMethods,
  }) = _KpiMetrics;

  factory KpiMetrics.fromJson(Map<String, dynamic> json) =>
      _$KpiMetricsFromJson(json);
}
