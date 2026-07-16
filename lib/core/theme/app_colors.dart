import 'package:flutter/material.dart';

/// ROMS Atelier semantic palette (platform — restaurant-agnostic).
///
/// Prefer semantic names (`ink`, `brand`, `canvas`). Legacy aliases
/// (`primary`, `background`, …) remain for gradual migration.
abstract final class AppColors {
  // ── Rainforest Sanctuary semantic ───────────────────────────────
  static const Color ink           = Color(0xFFE6EBE7); // Ink Primary  — warm alabaster
  static const Color inkMuted      = Color(0xFF829289); // Ink Muted    — mist grey-green
  static const Color inkDisabled   = Color(0xFF4E5C55);

  static const Color canvas        = Color(0xFF0A0F0D); // Canvas       — ultra-deep charcoal green
  static const Color surface       = Color(0xFF121815); // Surface      — soft muted moss stone
  static const Color surfaceRaised = Color(0xFF1A221E); // Surface Raised — elevated layer

  static const Color border        = Color(0xFF253029);
  static const Color borderStrong  = Color(0xFF3A4D42);
  static const Color divider       = Color(0xFF1F2B24);

  static const Color brand         = Color(0xFFC5A880); // Brand Gold   — desaturated champagne
  static const Color brandPressed  = Color(0xFFAD9067);
  static const Color brandSoft     = Color(0xFF2A2218);

  static const Color accent        = Color(0xFFBD6B42); // Accent       — damp earth terracotta
  static const Color accentSoft    = Color(0xFF291A11);

  static const Color success       = Color(0xFF3F5E4D); // Muted Sage Green
  static const Color successSoft   = Color(0xFF182820);
  static const Color warning       = Color(0xFFA88B5E); // Soft Amber Sand
  static const Color warningSoft   = Color(0xFF25200F);
  static const Color danger        = Color(0xFF9E473A); // Ochre Rust
  static const Color dangerSoft    = Color(0xFF261210);
  static const Color info          = Color(0xFF3A6080);
  static const Color infoSoft      = Color(0xFF0E1E2B);

  static const Color onBrand       = Color(0xFF0A0F0D);

  // ── Legacy aliases (do not remove — features still reference) ────
  static const Color primary        = brand;
  static const Color primaryDark    = brandPressed;
  static const Color primaryLight   = Color(0xFFD4BC98);
  static const Color secondary      = accent;
  static const Color secondaryDark  = Color(0xFF9A5230);
  static const Color secondaryLight = Color(0xFFCF8762);

  static const Color background     = canvas;
  static const Color surfaceVariant = surfaceRaised;

  static const Color textPrimary    = ink;
  static const Color textSecondary  = inkMuted;
  static const Color textDisabled   = inkDisabled;
  static const Color textOnPrimary  = onBrand;

  static const Color successLight   = successSoft;
  static const Color warningLight   = warningSoft;
  static const Color error          = danger;
  static const Color errorLight     = dangerSoft;
  static const Color infoLight      = infoSoft;

  // Status chips (domain)
  static const Color statusAvailable  = success;
  static const Color statusOccupied   = warning;
  static const Color statusReserved   = info;
  static const Color statusOutOfStock = danger;
}

/// Dark Rainforest Sanctuary surfaces (KDS / night staff).
/// Shares the same deep palette — dark mode is the primary mode.
abstract final class AppDarkColors {
  static const Color ink           = AppColors.ink;
  static const Color inkMuted      = AppColors.inkMuted;
  static const Color inkDisabled   = AppColors.inkDisabled;

  static const Color canvas        = AppColors.canvas;
  static const Color surface       = AppColors.surface;
  static const Color surfaceRaised = AppColors.surfaceRaised;
  static const Color border        = AppColors.border;
  static const Color divider       = AppColors.divider;

  static const Color brand         = AppColors.brand;
  static const Color brandPressed  = AppColors.brandPressed;
  static const Color brandSoft     = AppColors.brandSoft;
  static const Color accent        = AppColors.accent;
  static const Color accentSoft    = AppColors.accentSoft;

  static const Color onBrand       = AppColors.onBrand;

  // Legacy aliases
  static const Color background     = canvas;
  static const Color surfaceVariant = surfaceRaised;
  static const Color textPrimary    = ink;
  static const Color textSecondary  = inkMuted;
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
