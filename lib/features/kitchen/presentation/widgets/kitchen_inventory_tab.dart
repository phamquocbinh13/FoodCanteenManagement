import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/kitchen_provider.dart';
import 'kitchen_inventory_tile.dart';

/// Tab 3 — menu availability toggles with 3-column responsive grid grouped by categories.
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

    final List<KitchenMenuItemViewModel> riceItems = [];
    final List<KitchenMenuItemViewModel> beverageItems = [];
    final List<KitchenMenuItemViewModel> otherItems = [];

    for (final item in items) {
      final nameLower = item.name.toLowerCase();
      if (nameLower.contains('cơm') || nameLower.contains('rice')) {
        riceItems.add(item);
      } else if (nameLower.contains('trà') ||
          nameLower.contains('soda') ||
          nameLower.contains('coca') ||
          nameLower.contains('pepsi') ||
          nameLower.contains('sprite') ||
          nameLower.contains('nước') ||
          nameLower.contains('drink') ||
          nameLower.contains('beverage')) {
        beverageItems.add(item);
      } else {
        otherItems.add(item);
      }
    }

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
          : LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cols = w >= 900
                    ? 3
                    : w >= 600
                        ? 2
                        : 1;

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  children: [
                    if (riceItems.isNotEmpty) ...[
                      _CategoryHeader(title: 'RICE SELECTIONS'),
                      const SizedBox(height: 12.0),
                      _InventoryGrid(
                        items: riceItems,
                        cols: cols,
                        width: constraints.maxWidth,
                        kitchen: kitchen,
                      ),
                      const SizedBox(height: 32.0),
                    ],
                    if (beverageItems.isNotEmpty) ...[
                      _CategoryHeader(title: 'BEVERAGES'),
                      const SizedBox(height: 12.0),
                      _InventoryGrid(
                        items: beverageItems,
                        cols: cols,
                        width: constraints.maxWidth,
                        kitchen: kitchen,
                      ),
                      const SizedBox(height: 32.0),
                    ],
                    if (otherItems.isNotEmpty) ...[
                      _CategoryHeader(title: 'OTHER'),
                      const SizedBox(height: 12.0),
                      _InventoryGrid(
                        items: otherItems,
                        cols: cols,
                        width: constraints.maxWidth,
                        kitchen: kitchen,
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.inkMuted,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _InventoryGrid extends StatelessWidget {
  const _InventoryGrid({
    required this.items,
    required this.cols,
    required this.width,
    required this.kitchen,
  });

  final List<KitchenMenuItemViewModel> items;
  final int cols;
  final double width;
  final dynamic kitchen;

  @override
  Widget build(BuildContext context) {
    final gap = AppSpacing.sm;
    final itemWidth =
        cols == 1 ? width : (width - gap * (cols - 1)) / cols;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final item in items)
          SizedBox(
            width: itemWidth,
            child: KitchenInventoryTile(
              item: item,
              onTap: () => kitchen.toggleMenuItem(item.id),
            ),
          ),
      ],
    );
  }
}
