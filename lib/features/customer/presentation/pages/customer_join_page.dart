import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../providers/customer_session_provider.dart';

/// Deep-link join handler: `/join/:joinToken` resolves to [JoinSessionUseCase].
class JoinPage extends ConsumerStatefulWidget {
  const JoinPage({super.key, required this.joinToken});

  final String joinToken;

  @override
  ConsumerState<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends ConsumerState<JoinPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoJoin());
  }

  Future<void> _autoJoin() async {
    final controller = ref.read(customerSessionControllerProvider);
    final ok = await controller.join(widget.joinToken);
    if (!mounted) return;

    if (ok && controller.sessionToken != null) {
      context.go('/s/${controller.sessionToken}');
      return;
    }

    context.go('/customer');
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customerSessionControllerProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              controller.errorMessage ?? 'Joining session…',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
