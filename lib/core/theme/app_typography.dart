import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ROMS Atelier typography — Plus Jakarta Sans (UI) + Fraunces (display).
abstract final class AppTypography {
  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  static String get displayFontFamily => GoogleFonts.fraunces().fontFamily!;

  static TextTheme textThemeFor(Color ink, Color inkMuted) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    final display = GoogleFonts.frauncesTextTheme();

    TextStyle ui(
      TextStyle? s, {
      required double size,
      required FontWeight weight,
      required double height,
      Color? color,
    }) {
      return (s ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? ink,
        letterSpacing: 0,
      );
    }

    TextStyle hero(
      TextStyle? s, {
      required double size,
      required FontWeight weight,
      required double height,
    }) {
      return (s ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: ink,
        letterSpacing: -0.5,
      );
    }

    return TextTheme(
      displayLarge: hero(
        display.displayLarge,
        size: 32,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      displayMedium: hero(
        display.displayMedium,
        size: 28,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      displaySmall: ui(
        base.displaySmall,
        size: 24,
        weight: FontWeight.w600,
        height: 1.25,
      ),
      headlineLarge: ui(
        base.headlineLarge,
        size: 22,
        weight: FontWeight.w600,
        height: 1.25,
      ),
      headlineMedium: ui(
        base.headlineMedium,
        size: 20,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      headlineSmall: ui(
        base.headlineSmall,
        size: 18,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      titleLarge: ui(
        base.titleLarge,
        size: 16,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: ui(
        base.titleMedium,
        size: 14,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      titleSmall: ui(
        base.titleSmall,
        size: 12,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: ui(
        base.bodyLarge,
        size: 16,
        weight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: ui(
        base.bodyMedium,
        size: 14,
        weight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: ui(
        base.bodySmall,
        size: 13,
        weight: FontWeight.w400,
        height: 1.4,
        color: inkMuted,
      ),
      labelLarge: ui(
        base.labelLarge,
        size: 14,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: ui(
        base.labelMedium,
        size: 12,
        weight: FontWeight.w600,
        height: 1.2,
        color: inkMuted,
      ),
      labelSmall: ui(
        base.labelSmall,
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
  static TextStyle numberLarge(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle numberMedium(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
