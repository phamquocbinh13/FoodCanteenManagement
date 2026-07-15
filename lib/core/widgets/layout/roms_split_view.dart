import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';
import '../../theme/app_spacing.dart';

/// Master–detail layout for cashier POS from tablet width up.
class RomsSplitView extends StatelessWidget {
  const RomsSplitView({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth = 360,
    this.gap = AppSpacing.lg,
  });

  final Widget master;
  final Widget detail;
  final double masterWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (!AppBreakpoints.useSplitView(context)) {
      return detail;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: masterWidth, child: master),
        SizedBox(width: gap),
        Expanded(child: detail),
      ],
    );
  }
}
