import 'package:flutter/material.dart';

/// ROMS Atelier semantic palette (platform — restaurant-agnostic).
///
/// Prefer semantic names (`ink`, `brand`, `canvas`). Legacy aliases
/// (`primary`, `background`, …) remain for gradual migration.
abstract final class AppColors {
  // ── Atelier semantic ─────────────────────────────────────────────
  static const Color ink = Color(0xFF14201A);
  static const Color inkMuted = Color(0xFF5C6B63);
  static const Color inkDisabled = Color(0xFF9AA69F);

  static const Color canvas = Color(0xFFF3F5F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceRaised = Color(0xFFE8EDE9);

  static const Color border = Color(0xFFD5DDD7);
  static const Color borderStrong = Color(0xFFA8B5AD);
  static const Color divider = Color(0xFFD5DDD7);

  static const Color brand = Color(0xFF1F6B4A);
  static const Color brandPressed = Color(0xFF175338);
  static const Color brandSoft = Color(0xFFE3F2EA);

  static const Color accent = Color(0xFFC45C26);
  static const Color accentSoft = Color(0xFFF8E8DE);

  static const Color success = Color(0xFF2F6F4E);
  static const Color successSoft = Color(0xFFE4F3EB);
  static const Color warning = Color(0xFFB86E14);
  static const Color warningSoft = Color(0xFFFFF1DC);
  static const Color danger = Color(0xFFB42318);
  static const Color dangerSoft = Color(0xFFFCEBEA);
  static const Color info = Color(0xFF1F5C8A);
  static const Color infoSoft = Color(0xFFE7F1F8);

  static const Color onBrand = Color(0xFFFFFFFF);

  // ── Legacy aliases (do not remove — features still reference) ────
  static const Color primary = brand;
  static const Color primaryDark = brandPressed;
  static const Color primaryLight = Color(0xFF3FA87A);
  static const Color secondary = accent;
  static const Color secondaryDark = Color(0xFFA34A1A);
  static const Color secondaryLight = Color(0xFFE08A4F);

  static const Color background = canvas;
  static const Color surfaceVariant = surfaceRaised;

  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
  static const Color textDisabled = inkDisabled;
  static const Color textOnPrimary = onBrand;

  static const Color successLight = successSoft;
  static const Color warningLight = warningSoft;
  static const Color error = danger;
  static const Color errorLight = dangerSoft;
  static const Color infoLight = infoSoft;

  // Status chips (domain)
  static const Color statusAvailable = success;
  static const Color statusOccupied = warning;
  static const Color statusReserved = info;
  static const Color statusOutOfStock = danger;
}

/// Dark Atelier surfaces (KDS / night staff).
abstract final class AppDarkColors {
  static const Color ink = Color(0xFFF2F5F3);
  static const Color inkMuted = Color(0xFFA8B5AD);
  static const Color inkDisabled = Color(0xFF6B7870);

  static const Color canvas = Color(0xFF0E1210);
  static const Color surface = Color(0xFF1A211D);
  static const Color surfaceRaised = Color(0xFF243029);
  static const Color border = Color(0xFF334038);
  static const Color divider = Color(0xFF334038);

  static const Color brand = Color(0xFF3FA87A);
  static const Color brandPressed = Color(0xFF2F8A62);
  static const Color brandSoft = Color(0xFF1A3328);
  static const Color accent = Color(0xFFE08A4F);
  static const Color accentSoft = Color(0xFF3A2A1F);

  static const Color onBrand = Color(0xFF0E1210);

  // Legacy aliases
  static const Color background = canvas;
  static const Color surfaceVariant = surfaceRaised;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
}

/// Semantic tone for chips and banners.
enum StatusTone { neutral, success, warning, danger, info, brand, accent }

extension StatusToneColors on StatusTone {
  Color foreground(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (this) {
      StatusTone.neutral => dark ? AppDarkColors.ink : AppColors.ink,
      StatusTone.success => AppColors.success,
      StatusTone.warning => AppColors.warning,
      StatusTone.danger => AppColors.danger,
      StatusTone.info => AppColors.info,
      StatusTone.brand => dark ? AppDarkColors.brand : AppColors.brand,
      StatusTone.accent => dark ? AppDarkColors.accent : AppColors.accent,
    };
  }

  Color softBackground(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (this) {
      StatusTone.neutral =>
        dark ? AppDarkColors.surfaceRaised : AppColors.surfaceRaised,
      StatusTone.success =>
        dark ? AppColors.success.withValues(alpha: 0.2) : AppColors.successSoft,
      StatusTone.warning =>
        dark ? AppColors.warning.withValues(alpha: 0.2) : AppColors.warningSoft,
      StatusTone.danger =>
        dark ? AppColors.danger.withValues(alpha: 0.2) : AppColors.dangerSoft,
      StatusTone.info =>
        dark ? AppColors.info.withValues(alpha: 0.2) : AppColors.infoSoft,
      StatusTone.brand =>
        dark ? AppDarkColors.brandSoft : AppColors.brandSoft,
      StatusTone.accent =>
        dark ? AppDarkColors.accentSoft : AppColors.accentSoft,
    };
  }
}
