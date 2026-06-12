import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/routes/route_names.dart';

// Usage:
//   GoRoute(path: RouteNames.login, builder: (ctx, _) => const LoginScreen())
//
// On successful sign-in, navigates to RouteNames.punchIn using context.go()

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Stagger the entrance
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulated network call
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    context.go(RouteNames.punchIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                  vertical: AppDimensions.paddingXL,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Image.asset(
                          'assets/images/reflexion_logo.png',
                          width: 220,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Technician App',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Username field
                        _InputField(
                          controller: _usernameController,
                          hint: 'Username',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Enter your username' : null,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        _InputField(
                          controller: _passwordController,
                          hint: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Enter your password' : null,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleSignIn(),
                        ),
                        const SizedBox(height: 16),

                        // Remember me + Forgot password row
                        Row(
                          children: [
                            _RememberMeCheckbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  context.push(RouteNames.forgotPassword),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: AppColors.primaryLight,
                                textStyle: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Sign In button
                        SizedBox(
                          width: double.infinity,
                          height: AppDimensions.buttonHeight,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignIn,
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
                                : const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Version
                        Text(
                          'Version 1.0.0',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Logo Badge ──────────────────────────────────────────────────────────────

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryDark.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: 0.785398, // 45 degrees in radians
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable Input Field ─────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onFieldSubmitted;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 10),
          child: Icon(
            prefixIcon,
            size: AppDimensions.iconMD,
            color: AppColors.textTertiary,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: AppDimensions.inputHeight,
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    suffixIcon,
                    size: AppDimensions.iconMD,
                    color: AppColors.textTertiary,
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: AppDimensions.inputHeight,
        ),
      ),
    );
  }
}

// ── Remember Me Checkbox ─────────────────────────────────────────────────────

class _RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _RememberMeCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Remember Me',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
