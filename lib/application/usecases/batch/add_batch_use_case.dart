import '../../../application/menu/kitchen_batch_ticket.dart';
import '../../../application/usecases/batch/confirm_batch_use_case.dart';
import '../../../core/result/result.dart';
import '../../../domain/enums/domain_enums.dart';
import '../use_case.dart';

export 'confirm_batch_use_case.dart';

/// Confirms cart and creates immutable batch. Delegates to [ConfirmBatchUseCase].
final class AddBatchUseCase
    implements UseCase<KitchenBatchTicket, AddBatchParams> {
  AddBatchUseCase({required ConfirmBatchUseCase confirmBatch})
      : _confirmBatch = confirmBatch;

  final ConfirmBatchUseCase _confirmBatch;

  @override
  Future<Result<KitchenBatchTicket>> call(AddBatchParams params) {
    return _confirmBatch(
      ConfirmBatchParams(
        sessionId: params.sessionId,
        restaurantId: params.restaurantId,
        actorType: params.actorType,
        actorId: params.actorId,
      ),
    );
  }
}

final class AddBatchParams {
  const AddBatchParams({
    required this.sessionId,
    required this.restaurantId,
    this.actorType = ActorType.customerSession,
    this.actorId,
  });

  final String sessionId;
  final String restaurantId;
  final ActorType actorType;
  final String? actorId;
}
