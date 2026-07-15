import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/restaurant_brand.dart';
import '../../../../core/widgets/widgets.dart';
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
    final brand = RestaurantBrand.current;

    return Scaffold(
      backgroundColor: AppColors.canvas,
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
                    brand.displayName,
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (brand.tagline != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      brand.tagline!,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Join your table',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Scan the QR on your table, or enter the session code from staff.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  PrimaryButton(
                    label: 'Scan QR',
                    icon: Icons.qr_code_scanner_rounded,
                    isExpanded: true,
                    isLoading: false,
                    onPressed: controller.isLoading
                        ? null
                        : () => context.push(RoutePaths.customerScan),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          'OR',
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  RomsTextField(
                    controller: _codeController,
                    label: 'Session code',
                    hint: 'Paste code from staff',
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.vpn_key_outlined,
                    onSubmitted: (_) => _joinByCode(),
                    enabled: !controller.isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SecondaryButton(
                    label: 'Join with code',
                    isExpanded: true,
                    isLoading: controller.isLoading,
                    onPressed: controller.isLoading ? null : _joinByCode,
                  ),
                  AnimatedSize(
                    duration: AppMotion.duration(context, AppMotion.fast),
                    child: controller.errorMessage == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.lg),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.dangerSoft,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Text(
                                  controller.errorMessage!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.danger,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
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
