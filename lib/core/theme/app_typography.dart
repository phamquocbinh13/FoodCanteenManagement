import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ROMS Atelier typography — Plus Jakarta Sans (UI) + Fraunces (display).
///
/// Fonts are bundled under `assets/fonts/` for offline POS reliability.
abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const String displayFontFamily = 'Fraunces';

  static TextTheme textThemeFor(Color ink, Color inkMuted) {
    TextStyle ui({
      required double size,
      required FontWeight weight,
      required double height,
      Color? color,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? ink,
        letterSpacing: 0,
      );
    }

    TextStyle hero({
      required double size,
      required FontWeight weight,
      required double height,
    }) {
      return TextStyle(
        fontFamily: displayFontFamily,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: ink,
        letterSpacing: -0.5,
      );
    }

    return TextTheme(
      displayLarge: hero(size: 32, weight: FontWeight.w600, height: 1.2),
      displayMedium: hero(size: 28, weight: FontWeight.w600, height: 1.2),
      displaySmall: ui(size: 24, weight: FontWeight.w600, height: 1.25),
      headlineLarge: ui(size: 22, weight: FontWeight.w600, height: 1.25),
      headlineMedium: ui(size: 20, weight: FontWeight.w600, height: 1.3),
      headlineSmall: ui(size: 18, weight: FontWeight.w600, height: 1.3),
      titleLarge: ui(size: 16, weight: FontWeight.w600, height: 1.3),
      titleMedium: ui(size: 14, weight: FontWeight.w600, height: 1.3),
      titleSmall: ui(size: 12, weight: FontWeight.w600, height: 1.3),
      bodyLarge: ui(size: 16, weight: FontWeight.w400, height: 1.5),
      bodyMedium: ui(size: 14, weight: FontWeight.w400, height: 1.45),
      bodySmall: ui(
        size: 13,
        weight: FontWeight.w400,
        height: 1.4,
        color: inkMuted,
      ),
      labelLarge: ui(size: 14, weight: FontWeight.w600, height: 1.2),
      labelMedium: ui(
        size: 12,
        weight: FontWeight.w600,
        height: 1.2,
        color: inkMuted,
      ),
      labelSmall: ui(
        size: 11,
        weight: FontWeight.w500,
        height: 1.2,
        color: inkMuted,
      ),
    );
  }

  static TextTheme get textTheme =>
      textThemeFor(AppColors.ink, AppColors.inkMuted);

  static TextTheme get darkTextTheme =>
      textThemeFor(AppDarkColors.ink, AppDarkColors.inkMuted);

  /// Tabular money / batch numbers.
  static TextStyle numberLarge(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle numberMedium(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
