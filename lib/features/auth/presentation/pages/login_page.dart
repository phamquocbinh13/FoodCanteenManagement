import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authControllerProvider);
    final success = await auth.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted || !success) return;

    final route = auth.homeRoute();
    if (route != null) context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerListenableProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient background — 0.08 opacity per DESIGN_BIBLE §5
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/images/login/bg_ambience_forest.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/common/logo_gold.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'ROMS',
                          style: theme.textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Staff sign-in',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Operational access for your restaurant floor.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: !auth.isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: auth.isLoading
                              ? null
                              : () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                        ),
                      ),
                      onFieldSubmitted: (_) => _submit(),
                      enabled: !auth.isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        auth.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    PrimaryButton(
                      label: 'Sign in',
                      isLoading: auth.isLoading,
                      isExpanded: true,
                      onPressed: auth.isLoading ? null : _submit,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    RomsTextButton(
                      label: 'Guest? Join your table',
                      onPressed: () => context.go(RoutePaths.customer),
                    ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
