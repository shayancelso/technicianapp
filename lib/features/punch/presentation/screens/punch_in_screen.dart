import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/routes/route_names.dart';

class PunchInScreen extends StatefulWidget {
  const PunchInScreen({super.key});

  @override
  State<PunchInScreen> createState() => _PunchInScreenState();
}

class _PunchInScreenState extends State<PunchInScreen>
    with TickerProviderStateMixin {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  bool _hasSelfie = false;
  bool _isPunchingIn = false;
  String? _selectedLocation;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  final List<String> _locations = [
    'Head Office - Dubai',
    'Site A - Al Quoz',
    'Site B - Deira',
    'Site C - JBR',
    'Site D - Downtown',
  ];

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleTakeSelfie() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _hasSelfie = true);
  }

  Future<void> _handlePunchIn() async {
    if (!_hasSelfie) {
      _showSnack('Please take a selfie before punching in');
      return;
    }
    if (_selectedLocation == null) {
      _showSnack('Please select a location');
      return;
    }
    setState(() => _isPunchingIn = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isPunchingIn = false);
    context.go(RouteNames.dashboard);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: AppTextStyles.bodySmall.copyWith(color: Colors.white))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // ── Welcome Header ──
                      _buildWelcomeHeader(),
                      const SizedBox(height: 20),

                      // ── Date & Time Card ──
                      _buildDateTimeCard(),
                      const SizedBox(height: 16),

                      // ── Attendance Selfie Card ──
                      _buildSelfieCard(),
                      const SizedBox(height: 16),

                      // ── Location / Contract Card ──
                      _buildLocationCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ── Bottom: Punch In Button ──
              _buildPunchInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.textOnPrimary,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text('Demo Technician', style: AppTextStyles.h2),
            const SizedBox(height: 2),
            Text(
              "Let's get your day started.",
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeCard() {
    final dateStr = DateFormat('dd MMM yyyy').format(_now);
    final timeStr = DateFormat('h:mm:ss a').format(_now);
    final dayStr = DateFormat('EEEE').format(_now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Calendar icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE & TIME',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Date and time
          Text(
            '$dateStr  •  $timeStr',
            style: AppTextStyles.h2.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dayStr,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          // Auto captured note
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Auto captured • Not editable',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelfieCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ATTENDANCE SELFIE',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Required for verification',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Selfie circle
          Center(
            child: GestureDetector(
              onTap: _handleTakeSelfie,
              child: _hasSelfie
                  ? Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.success, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
                          const SizedBox(height: 6),
                          Text(
                            'Selfie captured',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CustomPaint(
                      painter: _DashedCirclePainter(),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.border.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primary.withValues(alpha: 0.6),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to take selfie',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Privacy note
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  'Photo is used for attendance verification only',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOCATION / CONTRACT',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Select the client, contract, or location you'll be working at today.",
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Dropdown
          Container(
            height: AppDimensions.inputHeight,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              color: AppColors.surface,
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _selectedLocation,
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: AppColors.textTertiary),
                      const SizedBox(width: 10),
                      Text(
                        'Select Location',
                        style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                  style: AppTextStyles.body,
                  dropdownColor: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  onChanged: (val) => setState(() => _selectedLocation = val),
                  items: _locations
                      .map((loc) => DropdownMenuItem<String>(
                            value: loc,
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: AppColors.accent),
                                const SizedBox(width: 8),
                                Text(loc, style: AppTextStyles.body),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Helper text
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'This helps us track where you\'re working.',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPunchInButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD, 12, AppDimensions.paddingMD, 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isPunchingIn ? null : _handlePunchIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                ),
                child: _isPunchingIn
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fingerprint_rounded, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'PUNCH IN',
                            style: AppTextStyles.button.copyWith(
                              letterSpacing: 1,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  'Your attendance data is secure and confidential.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashed Circle Painter ──
class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const dashCount = 40;
    const dashArc = (2 * pi) / dashCount;
    const gapFraction = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashArc;
      final sweepAngle = dashArc * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
