import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'menu_item_availability_history.freezed.dart';
part 'menu_item_availability_history.g.dart';

/// Append-only [MenuItem] availability change log. DATA_MODEL §3.30.
@freezed
abstract class MenuItemAvailabilityHistory with _$MenuItemAvailabilityHistory {
  const factory MenuItemAvailabilityHistory({
    required String id,
    required String menuItemId,
    required MenuAvailability fromAvailability,
    required MenuAvailability toAvailability,
    required String changedByUserId,
    required DateTime occurredAt,
  }) = _MenuItemAvailabilityHistory;

  factory MenuItemAvailabilityHistory.fromJson(Map<String, dynamic> json) =>
      _$MenuItemAvailabilityHistoryFromJson(json);
}
