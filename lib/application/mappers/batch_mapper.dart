import '../../domain/entities/kitchen_batch.dart';
import 'mapper.dart';

typedef BatchDto = Map<String, dynamic>;

final class BatchMapper implements BidirectionalMapper<KitchenBatch, BatchDto> {
  const BatchMapper();

  @override
  KitchenBatch toEntity(BatchDto dto) {
    throw UnimplementedError('BatchMapper.toEntity not implemented');
  }

  @override
  BatchDto toDto(KitchenBatch entity) {
    throw UnimplementedError('BatchMapper.toDto not implemented');
  }
}
