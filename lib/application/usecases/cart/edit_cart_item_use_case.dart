import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../../menu/customization_renderer.dart';
import '../../validators/customization_validator.dart';
import '../use_case.dart';

/// Updates customization selections and note on an existing cart line.
final class EditCartItemUseCase
    implements UseCase<SessionCartItem, EditCartItemParams> {
  EditCartItemUseCase({
    required SessionCartRepository cartRepository,
    required MenuRepository menuRepository,
    required CustomizationValidator customizationValidator,
    required CustomizationRenderer customizationRenderer,
    required IdGenerator idGenerator,
    required Clock clock,
    MenuDomainService? menuDomainService,
  })  : _cartRepository = cartRepository,
        _menuRepository = menuRepository,
        _customizationValidator = customizationValidator,
        _customizationRenderer = customizationRenderer,
        _idGenerator = idGenerator,
        _clock = clock,
        _menuService = menuDomainService ?? const MenuDomainService();

  final SessionCartRepository _cartRepository;
  final MenuRepository _menuRepository;
  final CustomizationValidator _customizationValidator;
  final CustomizationRenderer _customizationRenderer;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final MenuDomainService _menuService;

  @override
  Future<Result<SessionCartItem>> call(EditCartItemParams params) async {
    final found = await _cartRepository.findCartItem(
      sessionCartId: params.sessionCartId,
      itemId: params.cartItemId,
    );
    if (found is Err<SessionCartItem?>) return Err(found.failure);
    final existing = (found as Success<SessionCartItem?>).value;
    if (existing == null) {
      return const Err(NotFoundFailure('Cart item not found'));
    }

    final item = await _menuRepository.findItemById(
      restaurantId: params.restaurantId,
      menuItemId: existing.menuItemId,
    );
    if (item == null) {
      return const Err(NotFoundFailure('Menu item not found'));
    }

    try {
      _menuService.validateCanOrder(item);
    } on MenuRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    final groups = await _menuRepository.getGroupsByMenuItemId(existing.menuItemId);
    final optionsByGroupId = <String, List<dynamic>>{};
    for (final group in groups) {
      optionsByGroupId[group.id] =
          await _menuRepository.getOptionsByGroupId(group.id);
    }

    final validation = _customizationValidator.validate(
      groups: groups,
      optionsByGroupId: {
        for (final e in optionsByGroupId.entries) e.key: e.value.cast(),
      },
      selectionsJson: params.selectionsJson,
    );
    if (validation is Err<Map<String, List<String>>>) {
      return Err(validation.failure);
    }

    final rendered = _customizationRenderer.render(
      batchItemId: 'pending',
      basePrice: item.basePrice,
      groups: groups,
      optionsByGroupId: {
        for (final e in optionsByGroupId.entries) e.key: e.value.cast(),
      },
      selectionsJson: params.selectionsJson,
      idGenerator: _idGenerator,
      clock: _clock,
    );

    final updated = existing.copyWith(
      selectionsJson: params.selectionsJson,
      unitPriceSnapshot: rendered.unitPrice,
      updatedAt: _clock.now(),
    );
    return _cartRepository.saveCartItem(updated);
  }
}

final class EditCartItemParams {
  const EditCartItemParams({
    required this.sessionCartId,
    required this.cartItemId,
    required this.restaurantId,
    required this.selectionsJson,
  });

  final String sessionCartId;
  final String cartItemId;
  final String restaurantId;
  final Map<String, dynamic> selectionsJson;
}
