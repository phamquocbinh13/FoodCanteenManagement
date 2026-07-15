import '../../../core/network/http_api_client.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../use_case.dart';

final class RemoveBatchItemUseCase
    implements UseCase<void, RemoveBatchItemParams> {
  RemoveBatchItemUseCase({required BatchRepository batchRepository})
      : _batchRepository = batchRepository;

  final BatchRepository _batchRepository;

  @override
  Future<Result<void>> call(RemoveBatchItemParams params) async {
    try {
      await _batchRepository.deleteItem(
        restaurantId: params.restaurantId,
        batchItemId: params.batchItemId,
      );
      return const Success(null);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}

final class RemoveBatchItemParams {
  const RemoveBatchItemParams({
    required this.restaurantId,
    required this.batchItemId,
  });

  final String restaurantId;
  final String batchItemId;
}
