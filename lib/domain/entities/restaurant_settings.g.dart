// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantSettings _$RestaurantSettingsFromJson(
  Map<String, dynamic> json,
) => _RestaurantSettings(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  defaultCurrency: json['default_currency'] as String,
  taxRateBps: json['tax_rate_bps'] == null
      ? const Percentage(0)
      : const PercentageConverter().fromJson(
          (json['tax_rate_bps'] as num).toInt(),
        ),
  serviceChargeBps: json['service_charge_bps'] == null
      ? const Percentage(0)
      : const PercentageConverter().fromJson(
          (json['service_charge_bps'] as num).toInt(),
        ),
  sessionTokenTtlMinutes:
      (json['session_token_ttl_minutes'] as num?)?.toInt() ?? 480,
  allowQrOnReservedTable: json['allow_qr_on_reserved_table'] as bool? ?? false,
  paymentSoftLockEnabled: json['payment_soft_lock_enabled'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RestaurantSettingsToJson(_RestaurantSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'default_currency': instance.defaultCurrency,
      'tax_rate_bps': const PercentageConverter().toJson(instance.taxRateBps),
      'service_charge_bps': const PercentageConverter().toJson(
        instance.serviceChargeBps,
      ),
      'session_token_ttl_minutes': instance.sessionTokenTtlMinutes,
      'allow_qr_on_reserved_table': instance.allowQrOnReservedTable,
      'payment_soft_lock_enabled': instance.paymentSoftLockEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
