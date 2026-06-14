import '../entities/restaurant_table.dart';
import '../enums/domain_enums.dart';
import '../exceptions/domain_exception.dart';

/// Encapsulates [RestaurantTable] status transition rules.
///
/// Spec: no cleaning status. [occupied] only becomes [available] after
/// session closes (payment or force-close).
class TableDomainService {
  const TableDomainService();

  /// Returns whether [from] → [to] is a legal transition.
  bool canTransition(TableStatus from, TableStatus to) {
    return switch ((from, to)) {
      (TableStatus.available, TableStatus.occupied) => true,
      (TableStatus.available, TableStatus.reserved) => true,
      (TableStatus.reserved, TableStatus.occupied) => true,
      (TableStatus.reserved, TableStatus.available) => true,
      (TableStatus.occupied, TableStatus.available) => true,
      _ => false,
    };
  }

  /// Validates and returns updated table. Throws [TableRuleException] on illegal.
  RestaurantTable transition(RestaurantTable table, TableStatus to) {
    if (!canTransition(table.status, to)) {
      throw TableRuleException(
        'Illegal table status transition: ${table.status.name} → ${to.name}',
        code: 'INVALID_TABLE_TRANSITION',
      );
    }
    return table.copyWith(status: to, updatedAt: DateTime.now().toUtc());
  }

  /// Whether QR join is allowed on this table given settings.
  bool canJoinViaQr({
    required RestaurantTable table,
    required bool allowQrOnReservedTable,
  }) {
    if (!table.isActive) return false;
    return switch (table.status) {
      TableStatus.available => true,
      TableStatus.occupied => true,
      TableStatus.reserved => allowQrOnReservedTable,
    };
  }

  /// Table should be occupied when a session opens.
  RestaurantTable markOccupied(RestaurantTable table) =>
      transition(table, TableStatus.occupied);

  /// Table becomes available only after session closes.
  RestaurantTable markAvailable(RestaurantTable table) =>
      transition(table, TableStatus.available);
}
