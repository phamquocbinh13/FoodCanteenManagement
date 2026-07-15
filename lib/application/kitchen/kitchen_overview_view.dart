/// Aggregate kitchen awareness board (from GET /kitchen/overview).
final class KitchenOverviewView {
  const KitchenOverviewView({
    required this.totalActiveOrders,
    required this.totalFoodOrders,
    required this.totalDrinkOrders,
    required this.averageWaitingMinutes,
    required this.longestWaitingTable,
    required this.longestWaitingMinutes,
    required this.ordersReady,
    required this.ordersPreparing,
    required this.ordersWaiting,
    required this.menuDemand,
  });

  final int totalActiveOrders;
  final int totalFoodOrders;
  final int totalDrinkOrders;
  final num averageWaitingMinutes;
  final String? longestWaitingTable;
  final num longestWaitingMinutes;
  final int ordersReady;
  final int ordersPreparing;
  final int ordersWaiting;
  final List<KitchenMenuDemandRow> menuDemand;

  factory KitchenOverviewView.fromJson(Map<String, dynamic> json) {
    final demand = (json['menuDemand'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(KitchenMenuDemandRow.fromJson)
        .where((r) => r.quantity > 0)
        .toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return KitchenOverviewView(
      totalActiveOrders: (json['totalActiveOrders'] as num?)?.toInt() ?? 0,
      totalFoodOrders: (json['totalFoodOrders'] as num?)?.toInt() ?? 0,
      totalDrinkOrders: (json['totalDrinkOrders'] as num?)?.toInt() ?? 0,
      averageWaitingMinutes: json['averageWaitingMinutes'] as num? ?? 0,
      longestWaitingTable: json['longestWaitingTable'] as String?,
      longestWaitingMinutes: json['longestWaitingMinutes'] as num? ?? 0,
      ordersReady: (json['ordersReady'] as num?)?.toInt() ?? 0,
      ordersPreparing: (json['ordersPreparing'] as num?)?.toInt() ?? 0,
      ordersWaiting: (json['ordersWaiting'] as num?)?.toInt() ?? 0,
      menuDemand: demand,
    );
  }
}

final class KitchenMenuDemandRow {
  const KitchenMenuDemandRow({
    required this.menuItemId,
    required this.name,
    required this.quantity,
  });

  final String menuItemId;
  final String name;
  final int quantity;

  factory KitchenMenuDemandRow.fromJson(Map<String, dynamic> json) {
    return KitchenMenuDemandRow(
      menuItemId: json['menuItemId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}
