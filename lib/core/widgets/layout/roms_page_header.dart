import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/restaurant_brand.dart';

/// Standard page title block. Optionally shows restaurant brand for guests.
class RomsPageHeader extends StatelessWidget {
  const RomsPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showRestaurantBrand = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showRestaurantBrand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = RestaurantBrand.current;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showRestaurantBrand) ...[
                  Text(
                    brand.displayName,
                    style: theme.textTheme.displaySmall,
                  ),
                  if (brand.tagline != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      brand.tagline!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(title, style: theme.textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
