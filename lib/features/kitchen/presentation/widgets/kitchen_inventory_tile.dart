import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Menu availability row — one tap toggles instantly.
class KitchenInventoryTile extends StatelessWidget {
  const KitchenInventoryTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final KitchenMenuItemViewModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = item.isAvailable;

    return Material(
      color: available
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '🍛 ${item.name}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  available ? 'Đang bán' : 'Hết món',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: available
                        ? theme.colorScheme.onSecondaryContainer
                        : theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
