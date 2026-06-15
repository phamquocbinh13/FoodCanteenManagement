import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Splash screen: restores session or routes to login.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final auth = ref.read(authControllerProvider);
    await auth.checkAuthentication();
    if (!mounted) return;

    final route = auth.isAuthenticated
        ? auth.homeRoute() ?? RoutePaths.login
        : RoutePaths.login;

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingIndicator(message: 'Starting…'),
    );
  }
}
