import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/restaurant_table.dart';
import '../../../../domain/entities/session_engine_snapshot.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../controllers/cashier_session_controller.dart';

/// Compact floor map — high density table cards for rush hour.
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final crossAxisCount = w >= 720
            ? 5
            : w >= 520
                ? 4
                : w >= 360
                    ? 3
                    : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tables.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.xs,
            crossAxisSpacing: AppSpacing.xs,
            childAspectRatio: 1.35,
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
    final payDue =
        snapshot?.session.status == SessionStatus.paymentPending;
    final statusLabel = occupied
        ? (payDue ? 'Pay due' : 'Occ')
        : 'Free';

    final bg = selected
        ? AppColors.brandSoft
        : occupied
            ? (isDark ? AppDarkColors.surfaceRaised : AppColors.surfaceRaised)
            : (isDark ? AppDarkColors.surface : AppColors.surface);
    final border = selected
        ? AppColors.brand
        : payDue
            ? AppColors.danger
            : occupied
                ? AppColors.warning
                : AppColors.success.withValues(alpha: 0.55);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: border, width: selected ? 2 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  table.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  statusLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: payDue
                        ? AppColors.danger
                        : occupied
                            ? AppColors.warning
                            : AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (snapshot != null)
                  Text(
                    snapshot!.session.displayNumber,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
