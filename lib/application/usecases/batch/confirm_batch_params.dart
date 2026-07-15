import '../../../domain/enums/domain_enums.dart';

/// Params for confirm-batch use cases (local and server-owned).
final class ConfirmBatchParams {
  const ConfirmBatchParams({
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
