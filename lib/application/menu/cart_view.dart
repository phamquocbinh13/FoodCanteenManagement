import '../../domain/entities/session_cart.dart';
import '../../domain/entities/session_cart_item.dart';
import '../../domain/value_objects/money.dart';
import 'cart_line_view.dart';

/// Cart read model with subtotal and enriched lines for customer UI.
final class CartView {
  const CartView({
    required this.cart,
    required this.items,
    required this.lines,
    required this.subtotal,
  });

  final SessionCart cart;
  final List<SessionCartItem> items;
  final List<CartLineView> lines;
  final Money subtotal;

  bool get isEmpty => items.isEmpty;

  int get totalItemCount =>
      items.fold<int>(0, (sum, i) => sum + i.quantity.value);
}
