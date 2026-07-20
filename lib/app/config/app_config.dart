import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'restaurant_context.dart';

/// Application environment identifiers.
enum AppEnvironment {
  development,
  staging,
  production,
}

/// Centralized runtime configuration per environment.
///
/// Production architecture is remote-only (NestJS + MySQL).
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.restaurant,
  });

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;

  /// Active tenant for API paths and guest brand.
  final RestaurantContext restaurant;

  String get restaurantId => restaurant.restaurantId;

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;

  static AppConfig fromEnvironment(
    AppEnvironment env, {
    RestaurantContext? restaurant,
  }) {
    const envApiUrl = String.fromEnvironment('API_BASE_URL');
    String apiBaseUrl = envApiUrl;
    
    if (apiBaseUrl.isEmpty) {
      // Use 10.0.2.2 for Android emulator to reach host localhost, otherwise localhost
      if (!kIsWeb && Platform.isAndroid) {
        apiBaseUrl = 'http://10.0.2.2:3000/api/v1';
      } else {
        apiBaseUrl = 'http://localhost:3000/api/v1';
      }
    }
    final tenant = restaurant ?? RestaurantContext.fromEnvironment();

    return switch (env) {
      AppEnvironment.development => AppConfig(
          environment: AppEnvironment.development,
          appName: 'ROMS Dev',
          apiBaseUrl: apiBaseUrl,
          enableLogging: true,
          enableAnalytics: false,
          restaurant: tenant,
        ),
      AppEnvironment.staging => AppConfig(
          environment: AppEnvironment.staging,
          appName: 'ROMS Staging',
          apiBaseUrl: apiBaseUrl,
          enableLogging: true,
          enableAnalytics: true,
          restaurant: tenant,
        ),
      AppEnvironment.production => AppConfig(
          environment: AppEnvironment.production,
          appName: 'Food Canteen Management',
          apiBaseUrl: apiBaseUrl,
          enableLogging: false,
          enableAnalytics: true,
          restaurant: tenant,
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
