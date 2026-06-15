import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_payment_summary.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../menu/cart_view.dart';
import '../../session/session_bill_projector.dart';
import '../cart/get_session_cart_use_case.dart';
import '../use_case.dart';

/// Session bill = projection from confirmed batch snapshots (+ optional open cart).
final class GetSessionBillUseCase
    implements UseCase<SessionPaymentSummary, GetSessionBillParams> {
  GetSessionBillUseCase({
    required OrderingStore store,
    required SessionEngineDataSource sessionDataSource,
    required GetSessionCartUseCase getSessionCart,
  })  : _projector = SessionBillProjector(store: store),
        _sessionDataSource = sessionDataSource,
        _getSessionCart = getSessionCart;

  final SessionBillProjector _projector;
  final SessionEngineDataSource _sessionDataSource;
  final GetSessionCartUseCase _getSessionCart;

  @override
  Future<Result<SessionPaymentSummary>> call(GetSessionBillParams params) async {
    final session = _sessionDataSource.getSession(params.sessionId);
    if (session == null) {
      return const Err(NotFoundFailure('Session not found'));
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
        existing: session.paymentSummary,
        sessionId: params.sessionId,
        openCartSubtotalMinor: openCartSubtotalMinor,
      ),
    );
  }
}

final class GetSessionBillParams {
  const GetSessionBillParams({
    required this.sessionId,
    this.includeOpenCart = false,
  });

  final String sessionId;
  final bool includeOpenCart;
}
