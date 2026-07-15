import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/cashier_session_provider.dart';
import 'cashier_floor_grid.dart';
import 'cashier_session_detail_panel.dart';

/// Tab 1 — master–detail floor: select table → detail panel (no page nav).
class CashierFloorSessionsTab extends ConsumerWidget {
  const CashierFloorSessionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cashierSessionControllerProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final occupied = session.occupiedTableCount;
    final available = session.tables.length - occupied;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: RomsSplitView(
        detailWidth: 380,
        phoneMasterFlex: 3,
        phoneDetailFlex: 4,
        master: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Floor · next: tap a table',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '$occupied occ · $available free',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh floor',
                  icon: session.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 20),
                  onPressed: session.isLoading ? null : session.restore,
                ),
              ],
            ),
            if (session.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  session.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: session.restore,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: CashierFloorGrid(
                    session: session,
                    onTableTap: (table) async {
                      await session.onTableTapped(
                        table.id,
                        openedByUserId: user?.id,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        detail: const CashierSessionDetailPanel(),
      ),
    );
  }
}
