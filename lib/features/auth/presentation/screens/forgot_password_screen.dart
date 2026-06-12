import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';

// Usage:
//   GoRoute(path: RouteNames.forgotPassword, builder: (ctx, _) => const ForgotPasswordScreen())

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _sent = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _sent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.success, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Verification code sent to ${_emailController.text.trim()}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.surface),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
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
        title: const Text('Forgot Password'),
        titleTextStyle: AppTextStyles.h2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusCard),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.primary,
                          size: AppDimensions.iconLG,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Reset your password',
                        style: AppTextStyles.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the email address linked to your account. We\'ll send you a verification code.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: AppTextStyles.body,
                        onFieldSubmitted: (_) => _handleSend(),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter your email address';
                          }
                          final emailRx = RegExp(
                              r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                          if (!emailRx.hasMatch(v.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'your@email.com',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 14, right: 10),
                            child: Icon(
                              Icons.alternate_email_rounded,
                              size: AppDimensions.iconMD,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 44,
                            minHeight: AppDimensions.inputHeight,
                          ),
                          suffixIcon: _sent
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 14),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.success,
                                    size: AppDimensions.iconMD,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSend,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            AppColors.textOnPrimary),
                                  ),
                                )
                              : Text(
                                  _sent
                                      ? 'Resend Code'
                                      : 'Send Verification Code',
                                ),
                        ),
                      ),
                      if (_sent) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingMD),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCard),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppColors.success,
                                size: AppDimensions.iconMD,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Code sent! Check your inbox and use it to reset your password within 10 minutes.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.success,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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
