import '../../domain/entities/session_cart.dart';
import '../../domain/entities/session_cart_item.dart';
import '../../domain/value_objects/money.dart';

/// Cart read model with subtotal for customer UI.
final class CartView {
  const CartView({
    required this.cart,
    required this.items,
    required this.subtotal,
  });

  final SessionCart cart;
  final List<SessionCartItem> items;
  final Money subtotal;

  bool get isEmpty => items.isEmpty;
}
