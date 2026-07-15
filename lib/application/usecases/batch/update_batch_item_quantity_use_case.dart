import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../use_case.dart';

final class UpdateBatchItemQuantityUseCase
    implements UseCase<void, UpdateBatchItemQuantityParams> {
  UpdateBatchItemQuantityUseCase({required BatchRepository batchRepository})
      : _batchRepository = batchRepository;

  final BatchRepository _batchRepository;

  @override
  Future<Result<void>> call(UpdateBatchItemQuantityParams params) async {
    try {
      await _batchRepository.updateItemQuantity(
        restaurantId: params.restaurantId,
        batchItemId: params.batchItemId,
        delta: params.delta,
      );
      return const Success(null);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class UpdateBatchItemQuantityParams {
  const UpdateBatchItemQuantityParams({
    required this.restaurantId,
    required this.batchItemId,
    required this.delta,
  });

  final String restaurantId;
  final String batchItemId;
  final int delta;
}
