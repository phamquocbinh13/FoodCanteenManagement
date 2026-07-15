import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/restaurant_table.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../controllers/cashier_session_controller.dart';

/// Floor map of restaurant tables for cashier open / select.
class CashierFloorGrid extends StatelessWidget {
  const CashierFloorGrid({
    super.key,
    required this.session,
    required this.onTableTap,
  });

  final CashierSessionController session;
  final Future<void> Function(RestaurantTable table) onTableTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tables = session.tables;

    if (tables.isEmpty) {
      return Text(
        'No tables loaded. Pull to refresh.',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Floor', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Tap Available to open · tap Occupied to manage.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 480 ? 4 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tables.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final table = tables[index];
                final occupied = session.isTableOccupied(table.id);
                final selected =
                    session.activeSnapshot?.session.tableId == table.id;
                final snapshot = session.sessionForTable(table.id);
                return _FloorTableTile(
                  table: table,
                  occupied: occupied,
                  selected: selected,
                  snapshot: snapshot,
                  enabled: !session.isLoading,
                  onTap: () => onTableTap(table),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _FloorTableTile extends StatelessWidget {
  const _FloorTableTile({
    required this.table,
    required this.occupied,
    required this.selected,
    required this.snapshot,
    required this.enabled,
    required this.onTap,
  });

  final RestaurantTable table;
  final bool occupied;
  final bool selected;
  final SessionEngineSnapshot? snapshot;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusLabel = occupied
        ? (snapshot?.session.status == SessionStatus.paymentPending
            ? 'Pay due'
            : 'Occupied')
        : 'Available';

    final bg = selected
        ? AppColors.brandSoft
        : occupied
            ? (isDark ? AppDarkColors.surfaceRaised : AppColors.surfaceRaised)
            : (isDark ? AppDarkColors.surface : AppColors.surface);
    final border = selected
        ? AppColors.brand
        : occupied
            ? AppColors.warning
            : AppColors.success.withValues(alpha: 0.55);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: border, width: selected ? 2 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  table.label,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: occupied ? AppColors.warning : AppColors.success,
                  ),
                ),
                if (snapshot != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    snapshot!.session.displayNumber,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
