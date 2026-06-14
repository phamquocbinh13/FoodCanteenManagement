import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logger/app_logger.dart';
import 'app.dart';
import 'di/injection.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(
    () async {
      await Injection.init();

      final logger = sl<AppLogger>();
      logger.info('Application bootstrap complete', data: {
        'environment': Injection.config.environment.name,
        'apiBaseUrl': Injection.config.apiBaseUrl,
      });

      runApp(
        const ProviderScope(
          child: FoodCanteenManagementApp(),
        ),
      );
    },
    (error, stackTrace) {
      // Fallback before logger is available
      debugPrint('Uncaught error: $error\n$stackTrace');
    },
  );
}
