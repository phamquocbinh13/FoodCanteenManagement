import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../l10n/app_localizations.dart';
import 'di/injection.dart';
import 'router/app_router.dart';

class FoodCanteenManagementApp extends ConsumerStatefulWidget {
  const FoodCanteenManagementApp({super.key});

  @override
  ConsumerState<FoodCanteenManagementApp> createState() =>
      _FoodCanteenManagementAppState();
}

class _FoodCanteenManagementAppState
    extends ConsumerState<FoodCanteenManagementApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(sl<AuthController>());
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authControllerListenableProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: Injection.config.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
