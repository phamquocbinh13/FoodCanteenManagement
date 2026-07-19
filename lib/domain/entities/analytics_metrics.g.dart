// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductVelocity _$ProductVelocityFromJson(Map<String, dynamic> json) =>
    _ProductVelocity(
      id: json['id'] as String,
      name: json['name'] as String,
      quantitySold: (json['quantity_sold'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      currencyCode: json['currency_code'] as String,
      basePriceMinor: (json['base_price_minor'] as num).toInt(),
    );

Map<String, dynamic> _$ProductVelocityToJson(_ProductVelocity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity_sold': instance.quantitySold,
      'image_url': instance.imageUrl,
      'currency_code': instance.currencyCode,
      'base_price_minor': instance.basePriceMinor,
    };

_ProductVelocityData _$ProductVelocityDataFromJson(Map<String, dynamic> json) =>
    _ProductVelocityData(
      bestSellers:
          (json['best_sellers'] as List<dynamic>?)
              ?.map((e) => ProductVelocity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      worstSellers:
          (json['worst_sellers'] as List<dynamic>?)
              ?.map((e) => ProductVelocity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProductVelocityDataToJson(
  _ProductVelocityData instance,
) => <String, dynamic>{
  'best_sellers': instance.bestSellers.map((e) => e.toJson()).toList(),
  'worst_sellers': instance.worstSellers.map((e) => e.toJson()).toList(),
};

_PredictiveInsightsData _$PredictiveInsightsDataFromJson(
  Map<String, dynamic> json,
) => _PredictiveInsightsData(
  alerts:
      (json['alerts'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PredictiveInsightsDataToJson(
  _PredictiveInsightsData instance,
) => <String, dynamic>{'alerts': instance.alerts};

_RevenuePoint _$RevenuePointFromJson(Map<String, dynamic> json) =>
    _RevenuePoint(
      date: json['date'] as String,
      revenueMinor: (json['revenue_minor'] as num).toInt(),
    );

Map<String, dynamic> _$RevenuePointToJson(_RevenuePoint instance) =>
    <String, dynamic>{
      'date': instance.date,
      'revenue_minor': instance.revenueMinor,
    };

_HeatmapPoint _$HeatmapPointFromJson(Map<String, dynamic> json) =>
    _HeatmapPoint(
      hour: (json['hour'] as num).toInt(),
      intensity: (json['intensity'] as num).toInt(),
    );

Map<String, dynamic> _$HeatmapPointToJson(_HeatmapPoint instance) =>
    <String, dynamic>{'hour': instance.hour, 'intensity': instance.intensity};

_PaymentMethodSummary _$PaymentMethodSummaryFromJson(
  Map<String, dynamic> json,
) => _PaymentMethodSummary(
  method: json['method'] as String,
  totalMinor: (json['total_minor'] as num).toInt(),
);

Map<String, dynamic> _$PaymentMethodSummaryToJson(
  _PaymentMethodSummary instance,
) => <String, dynamic>{
  'method': instance.method,
  'total_minor': instance.totalMinor,
};

_KpiMetrics _$KpiMetricsFromJson(Map<String, dynamic> json) => _KpiMetrics(
  averageOrderValueMinor: (json['average_order_value_minor'] as num).toInt(),
  totalSessions: (json['total_sessions'] as num).toInt(),
  totalRevenueMinor: (json['total_revenue_minor'] as num).toInt(),
  paymentMethods:
      (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => PaymentMethodSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$KpiMetricsToJson(
  _KpiMetrics instance,
) => <String, dynamic>{
  'average_order_value_minor': instance.averageOrderValueMinor,
  'total_sessions': instance.totalSessions,
  'total_revenue_minor': instance.totalRevenueMinor,
  'payment_methods': instance.paymentMethods.map((e) => e.toJson()).toList(),
};
