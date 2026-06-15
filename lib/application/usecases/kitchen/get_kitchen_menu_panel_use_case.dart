import '../../../core/result/result.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../kitchen/kitchen_view_models.dart';
import '../use_case.dart';

/// Loads kitchen menu panel rows for availability toggles.
final class GetKitchenMenuPanelUseCase
    implements UseCase<List<KitchenMenuItemViewModel>, GetKitchenMenuPanelParams> {
  GetKitchenMenuPanelUseCase({required MenuRepository menuRepository})
      : _menuRepository = menuRepository;

  final MenuRepository _menuRepository;

  @override
  Future<Result<List<KitchenMenuItemViewModel>>> call(
    GetKitchenMenuPanelParams params,
  ) async {
    final items = await _menuRepository.listKitchenItems(params.restaurantId);
    return Success(
      items
          .map(
            (item) => KitchenMenuItemViewModel(
              id: item.id,
              name: item.name,
              isAvailable: item.availability == MenuAvailability.available,
            ),
          )
          .toList(),
    );
  }
}

final class GetKitchenMenuPanelParams {
  const GetKitchenMenuPanelParams({required this.restaurantId});

  final String restaurantId;
}
