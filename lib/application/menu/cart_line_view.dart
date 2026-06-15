import '../../domain/entities/session_cart_item.dart';
import '../../domain/value_objects/money.dart';

/// Enriched cart line for customer UI with resolved menu item name.
final class CartLineView {
  const CartLineView({
    required this.item,
    required this.menuItemName,
    required this.lineTotal,
  });

  final SessionCartItem item;
  final String menuItemName;
  final Money lineTotal;
}
