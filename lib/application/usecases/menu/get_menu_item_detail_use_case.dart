import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../menu/menu_item_detail_view.dart';
import '../use_case.dart';

/// Loads a menu item with modifier groups and options.
final class GetMenuItemDetailUseCase
    implements UseCase<MenuItemDetailView, GetMenuItemDetailParams> {
  GetMenuItemDetailUseCase({required MenuRepository menuRepository})
      : _menuRepository = menuRepository;

  final MenuRepository _menuRepository;

  @override
  Future<Result<MenuItemDetailView>> call(
    GetMenuItemDetailParams params,
  ) async {
    final item = await _menuRepository.findItemById(
      restaurantId: params.restaurantId,
      menuItemId: params.menuItemId,
    );
    if (item == null) {
      return const Err(NotFoundFailure('Menu item not found'));
    }

    final groups =
        await _menuRepository.getGroupsByMenuItemId(params.menuItemId);
    final optionsByGroupId = <String, List<dynamic>>{};
    for (final group in groups) {
      optionsByGroupId[group.id] =
          await _menuRepository.getOptionsByGroupId(group.id);
    }

    return Success(
      MenuItemDetailView(
        item: item,
        groups: groups,
        optionsByGroupId: {
          for (final e in optionsByGroupId.entries) e.key: e.value.cast(),
        },
      ),
    );
  }
}

final class GetMenuItemDetailParams {
  const GetMenuItemDetailParams({
    required this.restaurantId,
    required this.menuItemId,
  });

  final String restaurantId;
  final String menuItemId;
}
