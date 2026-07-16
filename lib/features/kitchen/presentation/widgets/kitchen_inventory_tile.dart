import 'package:flutter/material.dart';

import '../../../../application/kitchen/kitchen_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Menu availability row — clean switch indicator.
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
      color: AppColors.surface, // Surface background #121815
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: available ? AppColors.ink : AppColors.inkMuted,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Switch.adaptive(
                  value: available,
                  activeThumbColor: AppColors.brand, // Brand Gold #C5A880
                  activeTrackColor: AppColors.brand.withValues(alpha: 0.35),
                  inactiveThumbColor: AppColors.inkMuted,
                  inactiveTrackColor: AppColors.border,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
