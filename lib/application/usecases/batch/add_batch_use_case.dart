import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../use_case.dart';

/// Confirms cart and creates immutable batch. Sprint 5.
final class AddBatchUseCase implements UseCase<Object?, AddBatchParams> {
  AddBatchUseCase({required BatchRepository batchRepository})
      : _batchRepository = batchRepository;

  // ignore: unused_field
  final BatchRepository _batchRepository;

  @override
  Future<Result<Object?>> call(AddBatchParams params) async {
    return const Err(UnknownFailure('AddBatchUseCase not implemented'));
  }
}

final class AddBatchParams {
  const AddBatchParams({
    required this.sessionId,
    required this.restaurantId,
  });

  final String sessionId;
  final String restaurantId;
}
