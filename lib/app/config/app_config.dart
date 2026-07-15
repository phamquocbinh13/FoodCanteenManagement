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
    this.useRemoteBackend = false,
  });

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  /// When true, SessionEngine + Auth remotes talk to NestJS instead of in-memory.
  final bool useRemoteBackend;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;

  static AppConfig fromEnvironment(AppEnvironment env, {bool? useRemoteBackend}) {
    final remote = useRemoteBackend ?? false;
    final localApi = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:3000/api/v1',
    );

    return switch (env) {
      AppEnvironment.development => AppConfig(
          environment: AppEnvironment.development,
          appName: 'ROMS Dev',
          apiBaseUrl: remote ? localApi : 'https://dev-api.example.com',
          enableLogging: true,
          enableAnalytics: false,
          useRemoteBackend: remote,
        ),
      AppEnvironment.staging => AppConfig(
          environment: AppEnvironment.staging,
          appName: 'ROMS Staging',
          apiBaseUrl: remote ? localApi : 'https://staging-api.example.com',
          enableLogging: true,
          enableAnalytics: true,
          useRemoteBackend: remote,
        ),
      AppEnvironment.production => AppConfig(
          environment: AppEnvironment.production,
          appName: 'Food Canteen Management',
          apiBaseUrl: remote ? localApi : 'https://api.example.com',
          enableLogging: false,
          enableAnalytics: true,
          useRemoteBackend: remote,
        ),
    };
  }

  /// Resolved from compile-time dart-define, defaulting to development.
  static AppConfig current() {
    const envName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const useRemote = bool.fromEnvironment(
      'USE_REMOTE_BACKEND',
      defaultValue: false,
    );

    final env = AppEnvironment.values.firstWhere(
      (e) => e.name == envName,
      orElse: () => AppEnvironment.development,
    );

    return fromEnvironment(env, useRemoteBackend: useRemote);
  }
}
