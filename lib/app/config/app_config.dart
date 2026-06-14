/// Application environment identifiers.
enum AppEnvironment {
  development,
  staging,
  production,
}

/// Centralized runtime configuration per environment.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
  });

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;

  static AppConfig fromEnvironment(AppEnvironment env) {
    return switch (env) {
      AppEnvironment.development => const AppConfig(
          environment: AppEnvironment.development,
          appName: 'ROMS Dev',
          apiBaseUrl: 'https://dev-api.example.com',
          enableLogging: true,
          enableAnalytics: false,
        ),
      AppEnvironment.staging => const AppConfig(
          environment: AppEnvironment.staging,
          appName: 'ROMS Staging',
          apiBaseUrl: 'https://staging-api.example.com',
          enableLogging: true,
          enableAnalytics: true,
        ),
      AppEnvironment.production => const AppConfig(
          environment: AppEnvironment.production,
          appName: 'Food Canteen Management',
          apiBaseUrl: 'https://api.example.com',
          enableLogging: false,
          enableAnalytics: true,
        ),
    };
  }

  /// Resolved from compile-time dart-define, defaulting to development.
  static AppConfig current() {
    const envName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );

    final env = AppEnvironment.values.firstWhere(
      (e) => e.name == envName,
      orElse: () => AppEnvironment.development,
    );

    return fromEnvironment(env);
  }
}
