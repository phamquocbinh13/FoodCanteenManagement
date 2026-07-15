import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/kitchen_provider.dart';
import 'kitchen_inventory_tile.dart';

/// Tab 2 — menu availability toggles only.
class KitchenInventoryTab extends ConsumerStatefulWidget {
  const KitchenInventoryTab({super.key});

  @override
  ConsumerState<KitchenInventoryTab> createState() =>
      _KitchenInventoryTabState();
}

class _KitchenInventoryTabState extends ConsumerState<KitchenInventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final kitchen = ref.watch(kitchenControllerProvider);
    final items = kitchen.menuItems;

    return RefreshIndicator(
      onRefresh: kitchen.refresh,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                LoadingIndicator(message: 'Loading inventory…'),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = items[index];
                return KitchenInventoryTile(
                  item: item,
                  onTap: () => kitchen.toggleMenuItem(item.id),
                );
              },
            ),
    );
  }
}
