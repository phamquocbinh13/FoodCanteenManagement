import '../entities/menu_item.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Menu catalog and availability business rules.
///
/// Out of stock immediately hides from customers. Kitchen toggles availability.
class MenuDomainService {
  const MenuDomainService();

  /// Customer-visible catalog filter.
  bool isVisibleToCustomer(MenuItem item) {
    return item.isActive && item.availability == MenuAvailability.available;
  }

  /// Kitchen toggles availability (audited at persistence layer).
  MenuItem setAvailability({
    required MenuItem item,
    required MenuAvailability availability,
  }) {
    if (!item.isActive) {
      throw const MenuRuleException(
        'Cannot change availability of inactive menu item',
        code: 'MENU_ITEM_INACTIVE',
      );
    }
    return item.copyWith(
      availability: availability,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Whether item can be added to cart/order.
  void validateCanOrder(MenuItem item) {
    if (!isVisibleToCustomer(item)) {
      throw const MenuRuleException(
        'Menu item is not available for ordering',
        code: 'MENU_ITEM_UNAVAILABLE',
      );
    }
  }
}
