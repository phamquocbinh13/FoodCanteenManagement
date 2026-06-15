import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/value_objects/money.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../../menu/cart_view.dart';
import '../use_case.dart';

/// Returns the current session cart with subtotal.
final class GetSessionCartUseCase
    implements UseCase<CartView, GetSessionCartParams> {
  GetSessionCartUseCase({
    required SessionCartRepository cartRepository,
    required Clock clock,
  })  : _cartRepository = cartRepository,
        _clock = clock;

  final SessionCartRepository _cartRepository;
  final Clock _clock;

  @override
  Future<Result<CartView>> call(GetSessionCartParams params) async {
    final cartResult = await _cartRepository.getOrCreateCart(
      sessionId: params.sessionId,
      now: _clock.now(),
    );
    if (cartResult is Err<SessionCart>) return Err(cartResult.failure);

    final cart = (cartResult as Success<SessionCart>).value;
    final itemsResult = await _cartRepository.getCartItems(cart.id);
    if (itemsResult is Err<List<SessionCartItem>>) {
      return Err(itemsResult.failure);
    }

    final items = (itemsResult as Success<List<SessionCartItem>>).value;
    return Success(
      CartView(cart: cart, items: items, subtotal: _sumItems(items)),
    );
  }

  Money _sumItems(List<SessionCartItem> items) {
    if (items.isEmpty) {
      return const Money(amountMinor: 0, currencyCode: 'USD');
    }
    return items
        .map(
          (i) => Money(
            amountMinor: i.unitPriceSnapshot.amountMinor * i.quantity.value,
            currencyCode: i.unitPriceSnapshot.currencyCode,
          ),
        )
        .reduce((a, b) => a + b);
  }
}

final class GetSessionCartParams {
  const GetSessionCartParams({required this.sessionId});

  final String sessionId;
}
