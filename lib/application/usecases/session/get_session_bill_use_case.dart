import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_payment_summary.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../menu/cart_view.dart';
import '../cart/get_session_cart_use_case.dart';
import '../use_case.dart';

/// Session bill = sum of confirmed batch line totals (+ optional open cart).
final class GetSessionBillUseCase
    implements UseCase<SessionPaymentSummary, GetSessionBillParams> {
  GetSessionBillUseCase({
    required OrderingStore store,
    required SessionEngineDataSource sessionDataSource,
    required GetSessionCartUseCase getSessionCart,
  })  : _store = store,
        _sessionDataSource = sessionDataSource,
        _getSessionCart = getSessionCart;

  final OrderingStore _store;
  final SessionEngineDataSource _sessionDataSource;
  final GetSessionCartUseCase _getSessionCart;

  @override
  Future<Result<SessionPaymentSummary>> call(GetSessionBillParams params) async {
    final session = _sessionDataSource.getSession(params.sessionId);
    if (session == null) {
      return const Err(NotFoundFailure('Session not found'));
    }

    var subtotalMinor = 0;
    for (final batch in _store.batchesForSession(params.sessionId)) {
      final items = _store.batchItemsByBatchId[batch.id] ?? [];
      for (final item in items) {
        subtotalMinor += item.lineTotal.amountMinor;
      }
    }

    var summary = (session.paymentSummary ?? const SessionPaymentSummary())
        .copyWith(subtotalMinor: subtotalMinor)
        .recalculateTotal();

    if (params.includeOpenCart) {
      final cartResult = await _getSessionCart(
        GetSessionCartParams(sessionId: params.sessionId),
      );
      if (cartResult is Success<CartView>) {
        summary = summary
            .copyWith(
              subtotalMinor:
                  subtotalMinor + cartResult.value.subtotal.amountMinor,
            )
            .recalculateTotal();
      }
    }

    return Success(summary);
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
