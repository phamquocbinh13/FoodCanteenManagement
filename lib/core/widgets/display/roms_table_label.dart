import 'package:flutter/material.dart';

import '../../theme/app_colors.dart'; // StatusTone
import '../../theme/app_spacing.dart';
import '../feedback/status_chip.dart';

/// Table name with optional occupancy status.
class RomsTableLabel extends StatelessWidget {
  const RomsTableLabel({
    super.key,
    required this.label,
    this.statusLabel,
    this.tone,
    this.emphasize = false,
  });

  final String label;
  final String? statusLabel;
  final StatusTone? tone;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: emphasize
                ? theme.textTheme.headlineSmall
                : theme.textTheme.titleMedium,
          ),
        ),
        if (statusLabel != null && tone != null) ...[
          const SizedBox(width: AppSpacing.sm),
          StatusChip(label: statusLabel!, tone: tone!),
        ],
      ],
    );
  }
}
