import 'package:flutter/widgets.dart';

/// Layout breakpoints (logical px). Use via [AppBreakpoints.of] or helpers.
abstract final class AppBreakpoints {
  static const double phone = 0;
  static const double phoneLg = 428;
  static const double tablet = 768;
  static const double pos = 1024;
  static const double kds = 1280;
  static const double desktop = 1440;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static bool isPhone(BuildContext context) => widthOf(context) < tablet;

  static bool isPhoneLg(BuildContext context) =>
      widthOf(context) >= phoneLg && widthOf(context) < tablet;

  static bool isTablet(BuildContext context) =>
      widthOf(context) >= tablet && widthOf(context) < pos;

  static bool isPos(BuildContext context) =>
      widthOf(context) >= pos && widthOf(context) < kds;

  static bool isKds(BuildContext context) => widthOf(context) >= kds;

  static bool isDesktop(BuildContext context) => widthOf(context) >= desktop;

  /// Master–detail (cashier) from tablet up.
  static bool useSplitView(BuildContext context) => widthOf(context) >= tablet;

  /// Multi-column kitchen tickets from KDS width.
  static bool useKitchenRail(BuildContext context) => widthOf(context) >= kds;

  static int menuCrossAxisCount(BuildContext context) {
    final w = widthOf(context);
    if (w >= pos) return 3;
    if (w >= tablet) return 2;
    return 1;
  }
}
