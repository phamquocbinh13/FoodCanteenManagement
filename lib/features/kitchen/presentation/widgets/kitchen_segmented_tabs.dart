import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Kitchen tabs: Overview · Orders · Inventory.
class KitchenSegmentedTabs extends StatelessWidget {
  const KitchenSegmentedTabs({
    super.key,
    required this.controller,
    required this.activeOrderCount,
    required this.pendingBatchCount,
    required this.unavailableItemCount,
  });

  final TabController controller;
  final int activeOrderCount;
  final int pendingBatchCount;
  final int unavailableItemCount;

  @override
  Widget build(BuildContext context) {
    return StaffSegmentedTabs(
      controller: controller,
      tabs: [
        StaffTabSpec(label: 'Overview', count: activeOrderCount),
        StaffTabSpec(label: 'Orders', count: pendingBatchCount),
        StaffTabSpec(label: 'Inventory', count: unavailableItemCount),
      ],
    );
  }
}
