import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/kitchen_overview_provider.dart';
import '../providers/kitchen_provider.dart';
import '../widgets/kitchen_inventory_tab.dart';
import '../widgets/kitchen_orders_tab.dart';
import '../widgets/kitchen_overview_tab.dart';
import '../widgets/kitchen_workflow_tab.dart';
import '../widgets/kitchen_segmented_tabs.dart';
import '../providers/kitchen_workflow_provider.dart';

/// Kitchen Display System — Overview + Orders + Inventory.
class KitchenPage extends ConsumerStatefulWidget {
  const KitchenPage({super.key});

  @override
  ConsumerState<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends ConsumerState<KitchenPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _refreshTimer;

  final Set<String> _seenBatchIds = {};
  final Set<String> _highlightedBatchIds = {};
  bool _highlightsReady = false;
  bool _ordersLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      ref.invalidate(kitchenOverviewProvider);
      ref.invalidate(kitchenWorkflowProvider);
      if (_ordersLoaded) {
        ref.read(kitchenControllerProvider).refresh();
      }
    });
  }

  void _onTabChanged() {
    setState(() {});
    if ((_tabController.index == 2 || _tabController.index == 3) &&
        !_ordersLoaded) {
      _ordersLoaded = true;
      ref.read(kitchenControllerProvider).refresh();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onBatchesUpdated(List<KitchenBatchViewModel> batches) {
    final activeIds =
        batches.where((b) => b.isActive).map((b) => b.batchId).toSet();

    if (!_highlightsReady) {
      _seenBatchIds.addAll(activeIds);
      _highlightsReady = true;
      return;
    }

    for (final id in activeIds) {
      if (_seenBatchIds.contains(id)) continue;
      _seenBatchIds.add(id);
      setState(() => _highlightedBatchIds.add(id));
      Future<void>.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() => _highlightedBatchIds.remove(id));
      });
    }
  }

  int _pendingBatchCount(KitchenQueueView? queue) {
    if (queue == null) return 0;
    return queue.batches.where((b) => b.isActive).length;
  }

  int _unavailableCount(List<KitchenMenuItemViewModel> items) {
    return items.where((item) => !item.isAvailable).length;
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentRoleProvider);
    final kitchen = ref.watch(kitchenControllerProvider);
    final overview = ref.watch(kitchenOverviewProvider);
    final overviewCount = overview.asData?.value.totalActiveOrders ?? 0;

    return StaffScaffold(
      title: '',
      requiredPermission: AppPermission.viewKitchenQueue,
      body: Stack(
        children: [
          const AmbientBackdrop(
            imageAsset: 'assets/images/backgrounds/bg_kitchen_culinary.png',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (kDebugMode && role != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Center(child: StaffRoleBadge(role: role)),
              ],
              const SizedBox(height: AppSpacing.md),
              KitchenSegmentedTabs(
                controller: _tabController,
                activeOrderCount: overviewCount,
                pendingBatchCount: _pendingBatchCount(kitchen.queue),
                unavailableItemCount: _unavailableCount(kitchen.menuItems),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const KitchenOverviewTab(),
                    const KitchenWorkflowTab(),
                    KitchenOrdersTab(
                      highlightedBatchIds: _highlightedBatchIds,
                      onBatchesUpdated: _onBatchesUpdated,
                    ),
                    const KitchenInventoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
