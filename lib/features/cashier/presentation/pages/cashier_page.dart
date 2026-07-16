import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../request_queue/presentation/providers/request_queue_provider.dart';
import '../providers/cashier_session_provider.dart';
import '../widgets/cashier_edit_orders_tab.dart';
import '../widgets/cashier_floor_sessions_tab.dart';
import '../widgets/cashier_request_queue_tab.dart';
import '../widgets/cashier_segmented_tabs.dart';

/// Cashier POS — Floor sessions · Request queue · Edit kitchen orders.
class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _requestsLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    setState(() {});
    if (_tabController.index == 1 && !_requestsLoaded) {
      _requestsLoaded = true;
      ref.read(requestQueueControllerProvider).refresh();
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentRoleProvider);
    final session = ref.watch(cashierSessionControllerProvider);
    final queue = ref.watch(requestQueueControllerProvider);

    return StaffScaffold(
      title: 'Cashier',
      body: Stack(
        children: [
          const AmbientBackdrop(
            imageAsset: 'assets/images/backgrounds/bg_cashier_lobby.png',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (kDebugMode && role != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Center(child: StaffRoleBadge(role: role)),
              ],
              const SizedBox(height: AppSpacing.md),
              CashierSegmentedTabs(
                controller: _tabController,
                occupiedCount: session.occupiedTableCount,
                pendingRequestCount: queue.pendingCount,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    CashierFloorSessionsTab(),
                    CashierRequestQueueTab(),
                    CashierEditOrdersTab(),
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
