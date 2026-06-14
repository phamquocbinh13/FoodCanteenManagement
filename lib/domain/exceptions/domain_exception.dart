/// Base type for domain-layer rule violations.
///
/// UI and infrastructure map these to user-visible messages.
/// Domain services throw or return [DomainFailure] with these exceptions.
sealed class DomainException implements Exception {
  const DomainException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'DomainException($code): $message';
}

/// Session lifecycle or state rule violated.
final class SessionRuleException extends DomainException {
  const SessionRuleException(super.message, {super.code});
}

/// Batch immutability or parent XOR rule violated.
final class BatchRuleException extends DomainException {
  const BatchRuleException(super.message, {super.code});
}

/// Table status transition invalid.
final class TableRuleException extends DomainException {
  const TableRuleException(super.message, {super.code});
}

/// Payment or bill rule violated (e.g. split bill, double close).
final class PaymentRuleException extends DomainException {
  const PaymentRuleException(super.message, {super.code});
}

/// Kitchen visibility or item status rule violated.
final class KitchenRuleException extends DomainException {
  const KitchenRuleException(super.message, {super.code});
}

/// Request queue rule violated.
final class RequestRuleException extends DomainException {
  const RequestRuleException(super.message, {super.code});
}

/// Order / delivery pipeline rule violated.
final class OrderRuleException extends DomainException {
  const OrderRuleException(super.message, {super.code});
}

/// Menu or customization rule violated.
final class MenuRuleException extends DomainException {
  const MenuRuleException(super.message, {super.code});
}

/// Invalid value object construction.
final class ValueObjectException extends DomainException {
  const ValueObjectException(super.message, {super.code});
}
