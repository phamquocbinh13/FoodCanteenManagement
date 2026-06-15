import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../use_case.dart';

/// Kitchen locks a menu item (out of stock) — hides from customers.
final class LockMenuItemUseCase
    implements UseCase<MenuItem, LockMenuItemParams> {
  LockMenuItemUseCase({
    required MenuRepository menuRepository,
    required OrderingStore store,
    MenuDomainService? menuDomainService,
  })  : _menuRepository = menuRepository,
        _store = store,
        _menuService = menuDomainService ?? const MenuDomainService();

  final MenuRepository _menuRepository;
  final OrderingStore _store;
  final MenuDomainService _menuService;

  @override
  Future<Result<MenuItem>> call(LockMenuItemParams params) async {
    final item = await _menuRepository.findItemById(
      restaurantId: params.restaurantId,
      menuItemId: params.menuItemId,
    );
    if (item == null) {
      return const Err(NotFoundFailure('Menu item not found'));
    }

    final locked = _menuService.setAvailability(
      item: item,
      availability: MenuAvailability.outOfStock,
    );
    final saved = await _menuRepository.updateAvailability(locked);
    _store.menuCachedAt = null;
    return Success(saved);
  }
}

final class LockMenuItemParams {
  const LockMenuItemParams({
    required this.restaurantId,
    required this.menuItemId,
  });

  final String restaurantId;
  final String menuItemId;
}
