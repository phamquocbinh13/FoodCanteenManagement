import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'kitchen_batch.freezed.dart';
part 'kitchen_batch.g.dart';

/// Immutable kitchen work unit. Entity name: `Batch` in DATA_MODEL §3.12.
///
/// Created on every order confirmation. Parent is XOR: [sessionId] for dine-in
/// OR [orderId] for takeaway/delivery — never both. Never updated or merged.
@freezed
abstract class KitchenBatch with _$KitchenBatch {
  const factory KitchenBatch({
    required String id,
    required String restaurantId,
    String? sessionId,
    String? orderId,
    required int batchNumber,
    required DateTime confirmedAt,
    required ActorType confirmedByActorType,
    String? confirmedByActorId,
    required DateTime createdAt,
  }) = _KitchenBatch;

  factory KitchenBatch.fromJson(Map<String, dynamic> json) =>
      _$KitchenBatchFromJson(json);
}
