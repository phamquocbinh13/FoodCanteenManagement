import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../feedback/status_chip.dart';

/// Session display number + lifecycle phase.
class RomsSessionBadge extends StatelessWidget {
  const RomsSessionBadge({
    super.key,
    required this.displayNumber,
    this.phaseLabel,
    this.tone = StatusTone.neutral,
  });

  final String displayNumber;
  final String? phaseLabel;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayNumber,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (phaseLabel != null) ...[
          const SizedBox(width: AppSpacing.sm),
          StatusChip(label: phaseLabel!, tone: tone),
        ],
      ],
    );
  }
}
