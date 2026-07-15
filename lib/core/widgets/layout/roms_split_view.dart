import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';
import '../../theme/app_spacing.dart';

/// Master–detail layout for operational POS.
///
/// Tablet+: side-by-side. Phone: stacked (master then detail) so staff never
/// lose context — no page navigation required.
///
/// Pass [masterWidth] when the left pane is the narrow list (Edit Orders).
/// Pass [detailWidth] when the right pane is the narrow rail (Floor).
class RomsSplitView extends StatelessWidget {
  const RomsSplitView({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth,
    this.detailWidth = 360,
    this.gap = AppSpacing.sm,
    this.phoneMasterFlex = 2,
    this.phoneDetailFlex = 3,
  });

  final Widget master;
  final Widget detail;

  /// Fixed left width. When set, detail expands.
  final double? masterWidth;

  /// Fixed right width. Used when [masterWidth] is null (master expands).
  final double detailWidth;
  final double gap;

  final int phoneMasterFlex;
  final int phoneDetailFlex;

  @override
  Widget build(BuildContext context) {
    if (!AppBreakpoints.useSplitView(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: phoneMasterFlex, child: master),
          SizedBox(height: gap),
          Expanded(flex: phoneDetailFlex, child: detail),
        ],
      );
    }

    final wide = AppBreakpoints.widthOf(context) >= AppBreakpoints.desktop;
    final fixedMaster = masterWidth;
    if (fixedMaster != null) {
      final width = wide ? fixedMaster + 40 : fixedMaster;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: width, child: master),
          SizedBox(width: gap),
          Expanded(child: detail),
        ],
      );
    }

    final rail = wide ? detailWidth + 40 : detailWidth;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: master),
        SizedBox(width: gap),
        SizedBox(width: rail, child: detail),
      ],
    );
  }
}
