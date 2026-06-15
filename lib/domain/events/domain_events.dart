/// Marker for append-only domain occurrences.
///
/// No event bus is implemented in this sprint. Realtime modules (Sprint 13)
/// will subscribe to publishers that emit these contracts.
abstract interface class DomainEvent {
  String get eventId;
  DateTime get occurredAt;
  String get aggregateType;
  String get aggregateId;
}

/// Base class for typed domain events with shared metadata.
abstract base class DomainEventBase implements DomainEvent {
  const DomainEventBase({
    required this.eventId,
    required this.occurredAt,
    required this.aggregateType,
    required this.aggregateId,
  });

  @override
  final String eventId;

  @override
  final DateTime occurredAt;

  @override
  final String aggregateType;

  @override
  final String aggregateId;
}

/// Emitted when a dine-in session is opened.
final class SessionCreated extends DomainEventBase {
  const SessionCreated({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.tableId,
    required this.restaurantId,
    required this.displayNumber,
  }) : super(aggregateType: 'session');

  final String tableId;
  final String restaurantId;
  final String displayNumber;
}

/// Emitted when a session is closed and table released.
final class SessionClosedEvent extends DomainEventBase {
  const SessionClosedEvent({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.tableId,
  }) : super(aggregateType: 'session');

  final String tableId;
}

/// Emitted when a customer device joins via session token.
final class CustomerJoined extends DomainEventBase {
  const CustomerJoined({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    this.deviceId,
  }) : super(aggregateType: 'session');

  final String? deviceId;
}

/// Emitted when session enters waiting-for-payment state.
final class WaitingPaymentEntered extends DomainEventBase {
  const WaitingPaymentEntered({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
  }) : super(aggregateType: 'session');
}

/// Emitted when customer or staff requests payment.
final class PaymentRequested extends DomainEventBase {
  const PaymentRequested({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
  }) : super(aggregateType: 'session');
}

/// Emitted when a customer or cashier confirms an order batch.
final class BatchCreated extends DomainEventBase {
  const BatchCreated({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.batchNumber,
    this.sessionId,
    this.orderId,
  }) : super(aggregateType: 'batch');

  final int batchNumber;
  final String? sessionId;
  final String? orderId;
}

/// Emitted when kitchen marks a batch as fully completed.
final class BatchCompleted extends DomainEventBase {
  const BatchCompleted({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.batchNumber,
  }) : super(aggregateType: 'batch');

  final int batchNumber;
}

/// Emitted when cashier closes session payment.
final class PaymentCompleted extends DomainEventBase {
  const PaymentCompleted({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.sessionId,
    required this.amountMinor,
  }) : super(aggregateType: 'payment');

  final String sessionId;
  final int amountMinor;
}

/// Emitted when kitchen toggles a menu item out of stock.
final class MenuDisabled extends DomainEventBase {
  const MenuDisabled({
    required super.eventId,
    required super.occurredAt,
    required super.aggregateId,
    required this.menuItemId,
    required this.restaurantId,
  }) : super(aggregateType: 'menu_item');

  final String menuItemId;
  final String restaurantId;
}

/// Future publisher contract. No bus implementation in this sprint.
abstract interface class DomainEventPublisher {
  Future<void> publish(DomainEvent event);
}

/// No-op publisher until realtime infrastructure is wired.
final class NoOpDomainEventPublisher implements DomainEventPublisher {
  const NoOpDomainEventPublisher();

  @override
  Future<void> publish(DomainEvent event) async {}
}
