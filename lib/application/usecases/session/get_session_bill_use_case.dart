import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/session_engine_snapshot.dart';
import '../../../domain/entities/session_payment_summary.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../menu/cart_view.dart';
import '../../session/session_bill_projector.dart';
import '../cart/get_session_cart_use_case.dart';
import '../use_case.dart';

/// Session bill = projection from confirmed batch snapshots (+ optional open cart).
final class GetSessionBillUseCase
    implements UseCase<SessionPaymentSummary, GetSessionBillParams> {
  GetSessionBillUseCase({
    required SessionEngineRepository sessionRepository,
    required BatchRepository batchRepository,
    required GetSessionCartUseCase getSessionCart,
    SessionBillProjector projector = const SessionBillProjector(),
  })  : _sessionRepository = sessionRepository,
        _batchRepository = batchRepository,
        _getSessionCart = getSessionCart,
        _projector = projector;

  final SessionEngineRepository _sessionRepository;
  final BatchRepository _batchRepository;
  final GetSessionCartUseCase _getSessionCart;
  final SessionBillProjector _projector;

  @override
  Future<Result<SessionPaymentSummary>> call(GetSessionBillParams params) async {
    final sessionResult = await _sessionRepository.findById(
      sessionId: params.sessionId,
      restaurantId: params.restaurantId,
    );
    if (sessionResult is Err<SessionEngineSnapshot>) {
      return Err(sessionResult.failure);
    }
    if (sessionResult is! Success<SessionEngineSnapshot>) {
      return const Err(NotFoundFailure('Session not found'));
    }

    final snapshot = sessionResult.value;
    final items = <BatchItem>[];
    for (final batchId in snapshot.batchIds) {
      items.addAll(await _batchRepository.getItemsByBatchId(batchId));
    }

    var openCartSubtotalMinor = 0;
    if (params.includeOpenCart) {
      final cartResult = await _getSessionCart(
        GetSessionCartParams(sessionId: params.sessionId),
      );
      if (cartResult is Success<CartView>) {
        openCartSubtotalMinor = cartResult.value.subtotal.amountMinor;
      }
    }

    return Success(
      _projector.project(
        existing: snapshot.session.paymentSummary,
        batchSubtotalMinor: _projector.batchSubtotalMinor(items),
        openCartSubtotalMinor: openCartSubtotalMinor,
      ),
    );
  }
}

final class GetSessionBillParams {
  const GetSessionBillParams({
    required this.sessionId,
    required this.restaurantId,
    this.includeOpenCart = false,
  });

  final String sessionId;
  final String restaurantId;
  final bool includeOpenCart;
}
