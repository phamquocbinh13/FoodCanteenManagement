import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/json_converters.dart';
import '../value_objects/percentage.dart';

part 'restaurant_settings.freezed.dart';
part 'restaurant_settings.g.dart';

/// Per-venue operational configuration (tax, session TTL, QR on reserved).
///
/// DATA_MODEL §3.2 — one settings block per [Restaurant].
@freezed
abstract class RestaurantSettings with _$RestaurantSettings {
  const factory RestaurantSettings({
    required String id,
    required String restaurantId,
    required String defaultCurrency,
    @PercentageConverter() @Default(Percentage(0)) Percentage taxRateBps,
    @PercentageConverter()
    @Default(Percentage(0))
    Percentage serviceChargeBps,
    @Default(480) int sessionTokenTtlMinutes,
    @Default(false) bool allowQrOnReservedTable,
    @Default(true) bool paymentSoftLockEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RestaurantSettings;

  factory RestaurantSettings.fromJson(Map<String, dynamic> json) =>
      _$RestaurantSettingsFromJson(json);
}
