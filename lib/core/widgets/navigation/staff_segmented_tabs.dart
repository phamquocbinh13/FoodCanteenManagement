import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Enterprise segmented tab header with optional count badges (Cashier / Kitchen).
class StaffSegmentedTabs extends StatelessWidget {
  const StaffSegmentedTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<StaffTabSpec> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: TabBar(
          controller: controller,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.zero,
          indicator: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          labelStyle: theme.textTheme.labelLarge,
          unselectedLabelStyle: theme.textTheme.labelLarge,
          tabs: [
            for (var i = 0; i < tabs.length; i++)
              Tab(
                height: 48,
                child: _TabLabel(
                  title: tabs[i].label,
                  count: tabs[i].count,
                  selected: controller.index == i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class StaffTabSpec {
  const StaffTabSpec({required this.label, this.count = 0});

  final String label;
  final int count;
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.title,
    required this.count,
    required this.selected,
  });

  final String title;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showBadge = count > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (showBadge) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              '($count)',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
