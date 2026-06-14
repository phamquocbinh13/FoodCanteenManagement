import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'batch_item_status_history.freezed.dart';
part 'batch_item_status_history.g.dart';

/// Append-only [BatchItem] status transition log. DATA_MODEL §3.29.
@freezed
abstract class BatchItemStatusHistory with _$BatchItemStatusHistory {
  const factory BatchItemStatusHistory({
    required String id,
    required String batchItemId,
    BatchItemStatus? fromStatus,
    required BatchItemStatus toStatus,
    String? changedByUserId,
    required DateTime occurredAt,
  }) = _BatchItemStatusHistory;

  factory BatchItemStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$BatchItemStatusHistoryFromJson(json);
}
