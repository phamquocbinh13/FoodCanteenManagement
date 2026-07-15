import '../../../core/clock/clock.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../../../domain/value_objects/money.dart';
import '../../menu/cart_line_view.dart';
import '../../menu/cart_view.dart';
import '../../session/session_constants.dart';
import '../use_case.dart';

/// Returns the current session cart with subtotal and resolved item names.
final class GetSessionCartUseCase
    implements UseCase<CartView, GetSessionCartParams> {
  GetSessionCartUseCase({
    required SessionCartRepository cartRepository,
    required MenuRepository menuRepository,
    required Clock clock,
  })  : _cartRepository = cartRepository,
        _menuRepository = menuRepository,
        _clock = clock;

  final SessionCartRepository _cartRepository;
  final MenuRepository _menuRepository;
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
    final lines = await _buildLines(params.restaurantId, items);

    return Success(
      CartView(
        cart: cart,
        items: items,
        lines: lines,
        subtotal: _sumItems(items),
      ),
    );
  }

  Future<List<CartLineView>> _buildLines(
    String restaurantId,
    List<SessionCartItem> items,
  ) async {
    final lines = <CartLineView>[];
    for (final item in items) {
      final menuItem = await _menuRepository.findItemById(
        restaurantId: restaurantId,
        menuItemId: item.menuItemId,
      );
      lines.add(
        CartLineView(
          item: item,
          menuItemName: menuItem?.name ?? item.menuItemId,
          lineTotal: Money(
            amountMinor: item.unitPriceSnapshot.amountMinor * item.quantity.value,
            currencyCode: item.unitPriceSnapshot.currencyCode,
          ),
        ),
      );
    }
    return lines;
  }

  Money _sumItems(List<SessionCartItem> items) {
    if (items.isEmpty) {
      return const Money(amountMinor: 0, currencyCode: 'VND');
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
  const GetSessionCartParams({
    required this.sessionId,
    this.restaurantId = SessionEngineConstants.demoRestaurantId,
  });

  final String sessionId;
  final String restaurantId;
}
