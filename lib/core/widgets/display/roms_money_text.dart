import 'package:flutter/material.dart';

import '../../../shared/formatters/money_formatter.dart';
import '../../theme/app_typography.dart';

/// Consistent money display with tabular figures.
class RomsMoneyText extends StatelessWidget {
  const RomsMoneyText({
    super.key,
    required this.amountMinor,
    required this.currencyCode,
    this.style,
    this.large = false,
    this.color,
  });

  final int amountMinor;
  final String currencyCode;
  final TextStyle? style;
  final bool large;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? Theme.of(context).colorScheme.onSurface;
    final base = large
        ? AppTypography.numberLarge(ink)
        : AppTypography.numberMedium(ink);
    return Text(
      formatMoneyDisplay(
        amountMinor: amountMinor,
        currencyCode: currencyCode,
      ),
      style: style != null ? base.merge(style) : base,
    );
  }
}
