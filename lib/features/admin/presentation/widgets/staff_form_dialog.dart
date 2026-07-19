import 'package:flutter/material.dart';
import '../../../../domain/entities/staff_user.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class StaffFormDialog extends StatefulWidget {
  const StaffFormDialog({super.key, this.initialUser, this.isSelf = false});

  final StaffUser? initialUser;
  final bool isSelf;

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialUser?.displayName ?? '');
    _emailController = TextEditingController(text: widget.initialUser?.email ?? '');
    _passwordController = TextEditingController();
    _isActive = widget.initialUser?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'display_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'is_active': _isActive,
      };
      
      if (_passwordController.text.isNotEmpty) {
        data['password'] = _passwordController.text;
      }
      
      Navigator.of(context).pop(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialUser != null;
    
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Radius.lg
        side: BorderSide(color: AppColors.surfaceRaised),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'EDIT EMPLOYEE' : 'NEW EMPLOYEE',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.ink),
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: TextStyle(color: AppColors.inkMuted),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inkMuted),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brand),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.ink),
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: AppColors.inkMuted),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inkMuted),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brand),
                  ),
                ),
                validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: AppColors.ink),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isEditing ? 'New Password (Optional)' : 'Password',
                  labelStyle: const TextStyle(color: AppColors.inkMuted),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inkMuted),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brand),
                  ),
                ),
                validator: (val) {
                  if (!isEditing && (val == null || val.isEmpty)) {
                    return 'Required for new employees';
                  }
                  return null;
                },
              ),
              if (!widget.isSelf) ...[
                const SizedBox(height: AppSpacing.lg),
                SwitchListTile(
                  title: const Text('Account Active', style: TextStyle(color: AppColors.ink)),
                  value: _isActive,
                  activeTrackColor: AppColors.brand,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val;
                    });
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.inkMuted)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: AppColors.canvas,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(isEditing ? 'Save Changes' : 'Create Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
