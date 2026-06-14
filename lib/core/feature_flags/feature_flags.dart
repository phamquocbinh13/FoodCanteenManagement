import '../../app/config/app_config.dart';

/// Compile-time and runtime feature toggles.
///
/// Values can be overridden per environment via [AppConfig] in future sprints.
abstract final class FeatureFlags {
  static const bool enableKitchenRealtime = bool.fromEnvironment(
    'FF_KITCHEN_REALTIME',
    defaultValue: false,
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'FF_ANALYTICS',
    defaultValue: true,
  );

  static const bool enableOfflineMode = bool.fromEnvironment(
    'FF_OFFLINE_MODE',
    defaultValue: false,
  );

  static const bool enableDeliveryTracking = bool.fromEnvironment(
    'FF_DELIVERY_TRACKING',
    defaultValue: false,
  );

  /// Resolves a flag considering environment defaults.
  static bool isEnabled({
    required bool compileTimeFlag,
    AppEnvironment? environment,
  }) {
    if (!compileTimeFlag) return false;
    // Staging/production may enable flags that dev keeps off.
    return true;
  }
}
