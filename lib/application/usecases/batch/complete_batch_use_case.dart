import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../use_case.dart';

/// Marks batch kitchen work as completed. Sprint 6.
final class CompleteBatchUseCase implements UseCase<Object?, CompleteBatchParams> {
  CompleteBatchUseCase({required BatchRepository batchRepository})
      : _batchRepository = batchRepository;

  // ignore: unused_field
  final BatchRepository _batchRepository;

  @override
  Future<Result<Object?>> call(CompleteBatchParams params) async {
    return const Err(UnknownFailure('CompleteBatchUseCase not implemented'));
  }
}

final class CompleteBatchParams {
  const CompleteBatchParams({
    required this.batchId,
    required this.restaurantId,
  });

  final String batchId;
  final String restaurantId;
}
