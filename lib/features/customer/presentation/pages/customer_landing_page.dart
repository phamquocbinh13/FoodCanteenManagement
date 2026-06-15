import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/customer_session_provider.dart';

/// Customer entry: scan QR or enter the session code manually.
class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({super.key});

  @override
  ConsumerState<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryRestore());
  }

  Future<void> _tryRestore() async {
    final controller = ref.read(customerSessionControllerProvider);
    final restored = await controller.tryRestore();
    if (!mounted || !restored) return;
    final token = controller.sessionToken;
    if (token != null) {
      context.go('/s/$token');
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinByCode() async {
    final controller = ref.read(customerSessionControllerProvider);
    controller.clearError();
    final ok = await controller.join(_codeController.text);
    if (!mounted) return;
    if (ok && controller.sessionToken != null) {
      context.go('/s/${controller.sessionToken}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customerSessionControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome to Restaurant',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Join your dining session',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  FilledButton.icon(
                    onPressed: controller.isLoading
                        ? null
                        : () => context.push(RoutePaths.customerScan),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text('OR', style: theme.textTheme.labelMedium),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Enter Session Code',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      hintText: 'sess_…',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _joinByCode(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.tonal(
                    onPressed: controller.isLoading ? null : _joinByCode,
                    child: const Text('Join'),
                  ),
                  if (controller.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      controller.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
