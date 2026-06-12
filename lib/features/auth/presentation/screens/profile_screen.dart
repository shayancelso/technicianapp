import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/routes/route_names.dart';

// Usage:
//   GoRoute(path: RouteNames.profile, builder: (ctx, _) => const ProfileScreen())

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // Mock profile data
  final _fields = const [
    _ProfileField(label: 'First Name', value: 'Sampath'),
    _ProfileField(label: 'Last Name', value: 'S'),
    _ProfileField(label: 'Mobile', value: '+971 50 123 4567'),
    _ProfileField(label: 'Email', value: 'sampath@reflexion.ae'),
    _ProfileField(label: 'Designation', value: 'AC Technician'),
    _ProfileField(label: 'Department', value: 'HVAC & Mechanical'),
  ];

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
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
        title: const Text('Profile'),
        titleTextStyle: AppTextStyles.h2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + name header
                    Container(
                      width: double.infinity,
                      color: AppColors.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLG,
                        vertical: AppDimensions.paddingXL,
                      ),
                      child: Column(
                        children: [
                          _Avatar(initials: 'SS'),
                          const SizedBox(height: 16),
                          Text(
                            'S Sampath',
                            style: AppTextStyles.h2,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusChip),
                            ),
                            child: Text(
                              'AC Technician',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(height: 1, color: AppColors.border),

                    // Section header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.paddingLG,
                        AppDimensions.paddingLG,
                        AppDimensions.paddingLG,
                        0,
                      ),
                      child: Text(
                        'PERSONAL INFORMATION',
                        style: AppTextStyles.overline,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Fields list
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingMD),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _fields.length,
                        separatorBuilder: (_, __) => Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingMD),
                          color: AppColors.divider,
                        ),
                        itemBuilder: (context, index) {
                          final field = _fields[index];
                          return _ProfileFieldTile(field: field);
                        },
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),
                  ],
                ),
              ),
            ),

            // Bottom action
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
              child: OutlinedButton.icon(
                onPressed: () => context.push(RouteNames.changePassword),
                icon: const Icon(Icons.lock_outline_rounded,
                    size: AppDimensions.iconMD),
                label: const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryDark.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.h1.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────

class _ProfileField {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});
}

// ── Field tile ───────────────────────────────────────────────────────────────

class _ProfileFieldTile extends StatelessWidget {
  final _ProfileField field;

  const _ProfileFieldTile({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            field.value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
