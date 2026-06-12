import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';

// Usage:
//   GoRoute(path: RouteNames.changePassword, builder: (ctx, _) => const ChangePasswordScreen())

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();

    // Rebuild policy rows on new password changes
    _newPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.success, size: 18),
            const SizedBox(width: 10),
            Text(
              'Password updated successfully',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ),
    );

    if (mounted) Navigator.of(context).maybePop();
  }

  bool _meetsPolicy(String pwd) {
    return pwd.length >= 8 &&
        pwd.contains(RegExp(r'[A-Z]')) &&
        pwd.contains(RegExp(r'[0-9]'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Change Password'),
        titleTextStyle: AppTextStyles.h2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Section label
                        Text(
                          'SECURITY',
                          style: AppTextStyles.overline,
                        ),
                        const SizedBox(height: 16),

                        // Current password
                        _PasswordFieldTile(
                          label: 'Current Password',
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrent,
                          onToggle: () => setState(
                              () => _obscureCurrent = !_obscureCurrent),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Enter your current password';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),

                        // New password
                        _PasswordFieldTile(
                          label: 'New Password',
                          controller: _newPasswordController,
                          obscureText: _obscureNew,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Enter a new password';
                            }
                            if (!_meetsPolicy(v)) {
                              return 'Password does not meet requirements';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),

                        // Confirm password
                        _PasswordFieldTile(
                          label: 'Confirm New Password',
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (v != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleSubmit(),
                        ),
                        const SizedBox(height: 24),

                        // Policy card
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingMD),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusCard),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    size: AppDimensions.iconMD,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Password Requirements',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _PolicyRow(
                                text: 'At least 8 characters',
                                met: _newPasswordController.text.length >= 8,
                              ),
                              const SizedBox(height: 6),
                              _PolicyRow(
                                text: 'Contains an uppercase letter',
                                met: _newPasswordController.text
                                    .contains(RegExp(r'[A-Z]')),
                              ),
                              const SizedBox(height: 6),
                              _PolicyRow(
                                text: 'Contains a number',
                                met: _newPasswordController.text
                                    .contains(RegExp(r'[0-9]')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Submit button
              Container(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.paddingLG,
                  AppDimensions.paddingMD,
                  AppDimensions.paddingLG,
                  AppDimensions.paddingMD +
                      MediaQuery.of(context).padding.bottom,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textOnPrimary),
                            ),
                          )
                        : const Text('Update Password'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Password Field Tile ───────────────────────────────────────────────────────

class _PasswordFieldTile extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const _PasswordFieldTile({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggle,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Icons.lock_outline_rounded,
                size: AppDimensions.iconMD,
                color: AppColors.textTertiary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: AppDimensions.inputHeight,
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: AppDimensions.iconMD,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: AppDimensions.inputHeight,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Policy Row ───────────────────────────────────────────────────────────────

class _PolicyRow extends StatelessWidget {
  final String text;
  final bool met;

  const _PolicyRow({required this.text, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 14,
          color: met ? AppColors.success : AppColors.textTertiary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: met ? AppColors.success : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
