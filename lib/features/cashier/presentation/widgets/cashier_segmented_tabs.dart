import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Cashier top-level tabs: Floor / Requests / Edit orders.
class CashierSegmentedTabs extends StatelessWidget {
  const CashierSegmentedTabs({
    super.key,
    required this.controller,
    required this.occupiedCount,
    required this.pendingRequestCount,
  });

  final TabController controller;
  final int occupiedCount;
  final int pendingRequestCount;

  @override
  Widget build(BuildContext context) {
    return StaffSegmentedTabs(
      controller: controller,
      tabs: [
        StaffTabSpec(label: 'Floor', count: occupiedCount),
        StaffTabSpec(label: 'Requests', count: pendingRequestCount),
        const StaffTabSpec(label: 'Edit orders'),
      ],
    );
  }
}
