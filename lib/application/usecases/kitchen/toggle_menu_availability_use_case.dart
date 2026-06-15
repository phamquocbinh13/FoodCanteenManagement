import '../../../core/errors/failures.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/clock/clock.dart';
import '../use_case.dart';

/// Kitchen toggles menu item availability instantly (no confirmation).
final class ToggleMenuAvailabilityUseCase
    implements UseCase<MenuItem, ToggleMenuAvailabilityParams> {
  ToggleMenuAvailabilityUseCase({
    required MenuRepository menuRepository,
    required OrderingStore store,
    required DomainEventPublisher eventPublisher,
    required IdGenerator idGenerator,
    required Clock clock,
    MenuDomainService? menuDomainService,
  })  : _menuRepository = menuRepository,
        _store = store,
        _eventPublisher = eventPublisher,
        _idGenerator = idGenerator,
        _clock = clock,
        _menuService = menuDomainService ?? const MenuDomainService();

  final MenuRepository _menuRepository;
  final OrderingStore _store;
  final DomainEventPublisher _eventPublisher;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final MenuDomainService _menuService;

  @override
  Future<Result<MenuItem>> call(ToggleMenuAvailabilityParams params) async {
    final item = await _menuRepository.findItemById(
      restaurantId: params.restaurantId,
      menuItemId: params.menuItemId,
    );
    if (item == null) {
      return const Err(NotFoundFailure('Menu item not found'));
    }

    final nextAvailability = item.availability == MenuAvailability.available
        ? MenuAvailability.outOfStock
        : MenuAvailability.available;

    final updated = _menuService.setAvailability(
      item: item,
      availability: nextAvailability,
    );
    final saved = await _menuRepository.updateAvailability(updated);
    _store.bumpMenuVersion();

    final now = _clock.now();
    if (nextAvailability == MenuAvailability.outOfStock) {
      await _eventPublisher.publish(
        MenuDisabled(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: saved.id,
          menuItemId: saved.id,
          restaurantId: params.restaurantId,
        ),
      );
    } else {
      await _eventPublisher.publish(
        MenuUnlocked(
          eventId: _idGenerator.nextId(),
          occurredAt: now,
          aggregateId: saved.id,
          menuItemId: saved.id,
          restaurantId: params.restaurantId,
        ),
      );
    }

    return Success(saved);
  }
}

final class ToggleMenuAvailabilityParams {
  const ToggleMenuAvailabilityParams({
    required this.restaurantId,
    required this.menuItemId,
  });

  final String restaurantId;
  final String menuItemId;
}
