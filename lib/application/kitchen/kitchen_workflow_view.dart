/// Aggregate kitchen workflow view (from GET /kitchen/workflow).
final class KitchenWorkflowView {
  const KitchenWorkflowView({
    required this.buckets,
    required this.preparationSummary,
    required this.stats,
  });

  final Map<String, List<KitchenWorkflowItem>> buckets;
  final List<KitchenPreparationSummaryGroup> preparationSummary;
  final KitchenWorkflowStats stats;

  factory KitchenWorkflowView.fromJson(Map<String, dynamic> json) {
    final rawBuckets = json['buckets'] as Map<String, dynamic>? ?? {};
    final buckets = rawBuckets.map((key, value) {
      final list = (value as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(KitchenWorkflowItem.fromJson)
          .toList();
      return MapEntry(key, list);
    });

    final preparationSummary = (json['preparationSummary'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(KitchenPreparationSummaryGroup.fromJson)
        .toList();

    final stats = KitchenWorkflowStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {});

    return KitchenWorkflowView(
      buckets: buckets,
      preparationSummary: preparationSummary,
      stats: stats,
    );
  }
}

final class KitchenWorkflowItem {
  const KitchenWorkflowItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.oldestWaitingMinutes,
    required this.batchCount,
  });

  final String menuItemId;
  final String name;
  final int quantity;
  final int oldestWaitingMinutes;
  final int batchCount;

  factory KitchenWorkflowItem.fromJson(Map<String, dynamic> json) {
    return KitchenWorkflowItem(
      menuItemId: json['menuItemId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      oldestWaitingMinutes: (json['oldestWaitingMinutes'] as num?)?.toInt() ?? 0,
      batchCount: (json['batchCount'] as num?)?.toInt() ?? 0,
    );
  }
}

final class KitchenPreparationSummaryGroup {
  const KitchenPreparationSummaryGroup({
    required this.group,
    required this.options,
  });

  final String group;
  final List<KitchenPreparationSummaryOption> options;

  factory KitchenPreparationSummaryGroup.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(KitchenPreparationSummaryOption.fromJson)
        .toList();
    return KitchenPreparationSummaryGroup(
      group: json['group'] as String? ?? '',
      options: options,
    );
  }
}

final class KitchenPreparationSummaryOption {
  const KitchenPreparationSummaryOption({
    required this.name,
    required this.quantity,
  });

  final String name;
  final int quantity;

  factory KitchenPreparationSummaryOption.fromJson(Map<String, dynamic> json) {
    return KitchenPreparationSummaryOption(
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

final class KitchenWorkflowStats {
  const KitchenWorkflowStats({
    required this.oldestTicketMinutes,
    required this.mostOrderedItem,
    required this.totalFoodQty,
    required this.averageWaitingTimeMinutes,
  });

  final int oldestTicketMinutes;
  final String mostOrderedItem;
  final int totalFoodQty;
  final int averageWaitingTimeMinutes;

  factory KitchenWorkflowStats.fromJson(Map<String, dynamic> json) {
    return KitchenWorkflowStats(
      oldestTicketMinutes: (json['oldestTicketMinutes'] as num?)?.toInt() ?? 0,
      mostOrderedItem: json['mostOrderedItem'] as String? ?? 'None',
      totalFoodQty: (json['totalFoodQty'] as num?)?.toInt() ?? 0,
      averageWaitingTimeMinutes: (json['averageWaitingTimeMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}
