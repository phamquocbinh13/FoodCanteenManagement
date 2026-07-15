import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../../domain/value_objects/quantity.dart';
import '../../../domain/repositories/session_cart_repository.dart';
import '../../menu/customization_renderer.dart';
import '../../session/session_timeline_recorder.dart';
import '../../validators/customization_validator.dart';
import '../use_case.dart';

/// Adds a customized menu item to the session cart.
final class AddToCartUseCase implements UseCase<SessionCartItem, AddToCartParams> {
  AddToCartUseCase({
    required SessionCartRepository cartRepository,
    required MenuRepository menuRepository,
    required CustomizationValidator customizationValidator,
    required CustomizationRenderer customizationRenderer,
    required SessionTimelineRecorder timelineRecorder,
    required SessionEngineRepository sessionEngineRepository,
    required IdGenerator idGenerator,
    required Clock clock,
    MenuDomainService? menuDomainService,
  })  : _cartRepository = cartRepository,
        _menuRepository = menuRepository,
        _customizationValidator = customizationValidator,
        _customizationRenderer = customizationRenderer,
        _timeline = timelineRecorder,
        _sessionEngine = sessionEngineRepository,
        _idGenerator = idGenerator,
        _clock = clock,
        _menuService = menuDomainService ?? const MenuDomainService();

  final SessionCartRepository _cartRepository;
  final MenuRepository _menuRepository;
  final CustomizationValidator _customizationValidator;
  final CustomizationRenderer _customizationRenderer;
  final SessionTimelineRecorder _timeline;
  final SessionEngineRepository _sessionEngine;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final MenuDomainService _menuService;

  @override
  Future<Result<SessionCartItem>> call(AddToCartParams params) async {
    final item = await _menuRepository.findItemById(
      restaurantId: params.restaurantId,
      menuItemId: params.menuItemId,
    );
    if (item == null) {
      return const Err(NotFoundFailure('Menu item not found'));
    }

    try {
      _menuService.validateCanOrder(item);
    } on MenuRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    final groups = await _menuRepository.getGroupsByMenuItemId(params.menuItemId);
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

    final now = _clock.now();
    final cartResult = await _cartRepository.getOrCreateCart(
      sessionId: params.sessionId,
      now: now,
    );
    if (cartResult is Err<SessionCart>) return Err(cartResult.failure);
    final cart = (cartResult as Success<SessionCart>).value;

    final cartItem = SessionCartItem(
      id: _idGenerator.nextId(),
      sessionCartId: cart.id,
      menuItemId: item.id,
      quantity: Quantity(params.quantity),
      selectionsJson: params.selectionsJson,
      unitPriceSnapshot: rendered.unitPrice,
      createdAt: now,
      updatedAt: now,
    );

    final saveResult = await _cartRepository.saveCartItem(cartItem);
    if (saveResult is Err<SessionCartItem>) return Err(saveResult.failure);

    await _sessionEngine.appendTimeline(
      _timeline.cartItemAdded(
        sessionId: params.sessionId,
        menuItemId: item.id,
        quantity: params.quantity,
        actorId: params.actorId,
      ),
      restaurantId: params.restaurantId,
    );

    return saveResult;
  }
}

final class AddToCartParams {
  const AddToCartParams({
    required this.sessionId,
    required this.restaurantId,
    required this.menuItemId,
    required this.quantity,
    required this.selectionsJson,
    this.actorId,
  });

  final String sessionId;
  final String restaurantId;
  final String menuItemId;
  final int quantity;
  final Map<String, dynamic> selectionsJson;
  final String? actorId;
}
