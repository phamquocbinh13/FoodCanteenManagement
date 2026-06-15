import '../../../core/clock/clock.dart';
import '../../../core/errors/failures.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../domain/entities/session_cart.dart';
import '../../../domain/entities/session_cart_item.dart';
import '../../../domain/entities/batch_item.dart';
import '../../../domain/entities/kitchen_batch.dart';
import '../../../domain/enums/domain_enums.dart';
import '../../../domain/events/domain_events.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/repositories/batch_repository.dart';
import '../../../domain/repositories/menu_repository.dart';
import '../../../domain/repositories/session_engine_repository.dart';
import '../../../domain/services/batch_domain_service.dart';
import '../../../domain/services/menu_domain_service.dart';
import '../../../domain/value_objects/money.dart';
import '../../../data/datasources/ordering/ordering_store.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';
import '../../../data/repositories/cart/session_cart_repository_impl.dart';
import '../../menu/customization_renderer.dart';
import '../../menu/kitchen_batch_ticket.dart';
import '../../session/session_bill_projector.dart';
import '../../session/session_timeline_recorder.dart';
import '../use_case.dart';

/// Confirms cart → creates immutable batch → clears cart → updates session bill.
final class ConfirmBatchUseCase
    implements UseCase<KitchenBatchTicket, ConfirmBatchParams> {
  ConfirmBatchUseCase({
    required SessionCartRepository cartRepository,
    required BatchRepository batchRepository,
    required MenuRepository menuRepository,
    required SessionEngineRepository sessionEngineRepository,
    required SessionEngineDataSource sessionDataSource,
    required CustomizationRenderer customizationRenderer,
    required SessionTimelineRecorder timelineRecorder,
    required IdGenerator idGenerator,
    required DomainEventPublisher eventPublisher,
    required Clock clock,
    required OrderingStore orderingStore,
    BatchDomainService? batchDomainService,
    MenuDomainService? menuDomainService,
  })  : _cartRepository = cartRepository,
        _batchRepository = batchRepository,
        _menuRepository = menuRepository,
        _sessionEngine = sessionEngineRepository,
        _sessionDataSource = sessionDataSource,
        _customizationRenderer = customizationRenderer,
        _timeline = timelineRecorder,
        _idGenerator = idGenerator,
        _eventPublisher = eventPublisher,
        _clock = clock,
        _billProjector = SessionBillProjector(store: orderingStore),
        _batchService = batchDomainService ?? const BatchDomainService(),
        _menuService = menuDomainService ?? const MenuDomainService();

  final SessionCartRepository _cartRepository;
  final BatchRepository _batchRepository;
  final MenuRepository _menuRepository;
  final SessionEngineRepository _sessionEngine;
  final SessionEngineDataSource _sessionDataSource;
  final CustomizationRenderer _customizationRenderer;
  final SessionTimelineRecorder _timeline;
  final IdGenerator _idGenerator;
  final DomainEventPublisher _eventPublisher;
  final Clock _clock;
  final SessionBillProjector _billProjector;
  final BatchDomainService _batchService;
  final MenuDomainService _menuService;

  @override
  Future<Result<KitchenBatchTicket>> call(ConfirmBatchParams params) async {
    final now = _clock.now();
    final session = _sessionDataSource.getSession(params.sessionId);
    if (session == null || session.restaurantId != params.restaurantId) {
      return const Err(NotFoundFailure('Session not found'));
    }
    if (session.status == SessionStatus.closed) {
      return const Err(ValidationFailure('Session is closed'));
    }

    final cartResult = await _cartRepository.getOrCreateCart(
      sessionId: params.sessionId,
      now: now,
    );
    if (cartResult is Err<SessionCart>) return Err(cartResult.failure);
    final cart = (cartResult as Success<SessionCart>).value;

    final itemsResult = await _cartRepository.getCartItems(cart.id);
    if (itemsResult is Err<List<SessionCartItem>>) {
      return Err(itemsResult.failure);
    }
    final cartItems = (itemsResult as Success<List<SessionCartItem>>).value;

    try {
      _batchService.validateCartNotEmpty(cartItems);
    } on BatchRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    for (final line in cartItems) {
      final menuItem = await _menuRepository.findItemById(
        restaurantId: params.restaurantId,
        menuItemId: line.menuItemId,
      );
      if (menuItem == null) {
        return const Err(ValidationFailure('Menu item no longer exists'));
      }
      try {
        _menuService.validateCanOrder(menuItem);
      } on MenuRuleException catch (e) {
        return Err(ValidationFailure(e.message, code: e.code));
      }
    }

    final batchNumberResult = await _sessionEngine.nextBatchNumber(
      sessionId: params.sessionId,
      restaurantId: params.restaurantId,
    );
    if (batchNumberResult is Err<int>) return Err(batchNumberResult.failure);
    final batchNumber = (batchNumberResult as Success<int>).value;

    final batchId = _idGenerator.nextId();
    final batch = KitchenBatch(
      id: batchId,
      restaurantId: params.restaurantId,
      sessionId: params.sessionId,
      batchNumber: batchNumber,
      confirmedAt: now,
      confirmedByActorType: params.actorType,
      confirmedByActorId: params.actorId,
      createdAt: now,
    );

    try {
      _batchService.validateNewBatch(batch);
    } on BatchRuleException catch (e) {
      return Err(ValidationFailure(e.message, code: e.code));
    }

    await _batchRepository.create(batch);

    final batchItems = <BatchItem>[];

    for (final line in cartItems) {
      final menuItem = (await _menuRepository.findItemById(
        restaurantId: params.restaurantId,
        menuItemId: line.menuItemId,
      ))!;

      final groups =
          await _menuRepository.getGroupsByMenuItemId(line.menuItemId);
      final optionsByGroupId = <String, List<dynamic>>{};
      for (final group in groups) {
        optionsByGroupId[group.id] =
            await _menuRepository.getOptionsByGroupId(group.id);
      }

      final batchItemId = _idGenerator.nextId();
      final rendered = _customizationRenderer.render(
        batchItemId: batchItemId,
        basePrice: menuItem.basePrice,
        groups: groups,
        optionsByGroupId: {
          for (final e in optionsByGroupId.entries) e.key: e.value.cast(),
        },
        selectionsJson: line.selectionsJson,
        idGenerator: _idGenerator,
        clock: _clock,
      );

      final lineTotal = Money(
        amountMinor: rendered.unitPrice.amountMinor * line.quantity.value,
        currencyCode: rendered.unitPrice.currencyCode,
      );

      final batchItem = BatchItem(
        id: batchItemId,
        batchId: batchId,
        menuItemId: line.menuItemId,
        menuItemNameSnapshot: menuItem.name,
        unitPriceSnapshot: rendered.unitPrice,
        quantity: line.quantity,
        lineTotal: lineTotal,
        kitchenNotesRendered: rendered.kitchenNotes,
        statusUpdatedAt: now,
        createdAt: now,
      );
      await _batchRepository.createItem(batchItem);
      await _batchRepository.createCustomizations(rendered.mods);
      batchItems.add(batchItem);
    }

    await _cartRepository.clearCart(params.sessionId);

    final latestSession = _sessionDataSource.getSession(params.sessionId)!;
    final projectedSummary = _billProjector.project(
      existing: latestSession.paymentSummary,
      sessionId: params.sessionId,
    );

    final updatedSession = latestSession.copyWith(
      paymentSummary: projectedSummary,
      updatedAt: now,
    );
    await _sessionEngine.update(updatedSession);

    _sessionDataSource.appendTimeline(
      _timeline.batchCreated(
        sessionId: params.sessionId,
        batchNumber: batchNumber,
        actorId: params.actorId,
      ),
    );

    await _eventPublisher.publish(
      BatchCreated(
        eventId: _idGenerator.nextId(),
        occurredAt: now,
        aggregateId: batchId,
        batchNumber: batchNumber,
        sessionId: params.sessionId,
      ),
    );

    final table = _sessionDataSource.getTable(session.tableId);
    return Success(
      KitchenBatchTicket(
        batch: batch,
        tableLabel: table?.label ?? session.tableId,
        items: batchItems,
      ),
    );
  }
}

final class ConfirmBatchParams {
  const ConfirmBatchParams({
    required this.sessionId,
    required this.restaurantId,
    this.actorType = ActorType.customerSession,
    this.actorId,
  });

  final String sessionId;
  final String restaurantId;
  final ActorType actorType;
  final String? actorId;
}
