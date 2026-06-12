import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';
import '../../../../config/routes/route_names.dart';

// ── Status Pipeline Data ──────────────────────────────────────────────────────

class _StatusStep {
  final WOStatus status;
  final String label;
  final IconData icon;

  const _StatusStep({
    required this.status,
    required this.label,
    required this.icon,
  });
}

const _pipeline = [
  _StatusStep(
    status: WOStatus.assigned,
    label: 'Assigned',
    icon: Icons.assignment_outlined,
  ),
  _StatusStep(
    status: WOStatus.tripStarted,
    label: 'Trip Started',
    icon: Icons.directions_car_outlined,
  ),
  _StatusStep(
    status: WOStatus.siteAttended,
    label: 'Site Attended',
    icon: Icons.location_on_outlined,
  ),
  _StatusStep(
    status: WOStatus.workStarted,
    label: 'Work Started',
    icon: Icons.build_outlined,
  ),
  _StatusStep(
    status: WOStatus.workCompleted,
    label: 'Completed',
    icon: Icons.check_circle_outline_rounded,
  ),
];

// ── Next Status Options ───────────────────────────────────────────────────────

class _NextStatusOption {
  final WOStatus status;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const _NextStatusOption({
    required this.status,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

const _nextOptions = [
  _NextStatusOption(
    status: WOStatus.tripStarted,
    title: 'Start Trip',
    description: 'Mark that you are now traveling to the job site.',
    icon: Icons.directions_car_rounded,
    iconColor: AppColors.info,
  ),
  _NextStatusOption(
    status: WOStatus.siteAttended,
    title: 'Mark Site Attended',
    description: 'Confirm you have arrived and are on-site.',
    icon: Icons.location_on_rounded,
    iconColor: AppColors.warning,
  ),
  _NextStatusOption(
    status: WOStatus.workStarted,
    title: 'Start Work',
    description: 'Begin active work on the reported fault or task.',
    icon: Icons.build_rounded,
    iconColor: AppColors.success,
  ),
  _NextStatusOption(
    status: WOStatus.workCompleted,
    title: 'Complete Work Order',
    description: 'Mark all tasks done and close the work order.',
    icon: Icons.check_circle_rounded,
    iconColor: AppColors.primary,
  ),
];

// ── Main Screen ───────────────────────────────────────────────────────────────

class ChangeStatusScreen extends StatefulWidget {
  final String workOrderId;

  const ChangeStatusScreen({super.key, required this.workOrderId});

  @override
  State<ChangeStatusScreen> createState() => _ChangeStatusScreenState();
}

class _ChangeStatusScreenState extends State<ChangeStatusScreen> {
  WOStatus _currentStatus = WOStatus.assigned;
  WOStatus? _selectedNext;
  final TextEditingController _remarksController = TextEditingController();
  int _photoCount = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  int get _currentStepIndex =>
      _pipeline.indexWhere((s) => s.status == _currentStatus);

  List<_NextStatusOption> get _validOptions {
    final idx = _currentStepIndex;
    if (idx < 0) return _nextOptions;
    return _nextOptions
        .where((o) =>
            _pipeline.indexWhere((s) => s.status == o.status) > idx)
        .toList();
  }

  void _showDelayDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DelayBottomSheet(
        onSubmit: (reason) {
          Navigator.pop(context);
          setState(() => _currentStatus = WOStatus.delayed);
          _showSnack('Delay reported: $reason');
        },
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodySmall),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
      ),
    );
  }

  Future<void> _submitStatus() async {
    if (_selectedNext == null) {
      _showSnack('Please select a next status');
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final nextStatus = _selectedNext!;

    // If completed, navigate back to dashboard
    if (nextStatus == WOStatus.workCompleted) {
      setState(() => _isSubmitting = false);
      _showSnack('Work Order Completed!');
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.go(RouteNames.dashboard);
      return;
    }

    setState(() {
      _isSubmitting = false;
      _currentStatus = nextStatus;
      _selectedNext = null;
      _remarksController.clear();
      _photoCount = 0;
    });
    _showSnack('Status updated to: ${_currentStatus.label}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
        ),
        title: Text('Change Status', style: AppTextStyles.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: AppDimensions.paddingLG + 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Pipeline Stepper ──
                  _buildPipeline(),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // ── Current Status Label ──
                  _buildCurrentStatusCard(),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // ── Next Status Options ──
                  _buildSectionLabel('SELECT NEXT STATUS'),
                  ..._validOptions.map((opt) => _NextStatusCard(
                        option: opt,
                        isSelected: _selectedNext == opt.status,
                        onTap: () =>
                            setState(() => _selectedNext = opt.status),
                      )),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // ── Remarks Field ──
                  _buildSectionLabel('REMARKS / DESCRIPTION'),
                  _buildRemarksField(),
                  const SizedBox(height: AppDimensions.paddingMD),
                  // ── Photo Section ──
                  _buildSectionLabel('PHOTOS'),
                  _buildPhotoSection(),
                  const SizedBox(height: AppDimensions.paddingLG),
                ],
              ),
            ),
          ),
          // ── Bottom Action Bar ──
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildPipeline() {
    final currentIdx = _currentStepIndex;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingLG,
        AppDimensions.paddingMD,
        AppDimensions.paddingLG,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 72,
            child: Row(
              children: _pipeline.asMap().entries.map((entry) {
                final idx = entry.key;
                final step = entry.value;
                final isCompleted = idx < currentIdx;
                final isCurrent = idx == currentIdx;
                final isLast = idx == _pipeline.length - 1;

                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StepCircle(
                              isCompleted: isCompleted,
                              isCurrent: isCurrent,
                              icon: step.icon,
                              index: idx + 1,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              step.label,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 9,
                                color: isCurrent || isCompleted
                                    ? AppColors.primary
                                    : AppColors.textTertiary,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 24,
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppColors.success
                                    : AppColors.border,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(Icons.my_location_rounded,
                color: AppColors.textOnPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT STATUS',
                style: AppTextStyles.overline.copyWith(fontSize: 9),
              ),
              const SizedBox(height: 2),
              Text(
                _currentStatus.label,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        0,
        AppDimensions.paddingMD,
        AppDimensions.paddingXS,
      ),
      child: Text(label, style: AppTextStyles.overline),
    );
  }

  Widget _buildRemarksField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: _remarksController,
          maxLines: 4,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText:
                'Add notes or description about the status change…',
            hintStyle: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textTertiary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(AppDimensions.paddingMD),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: GestureDetector(
        onTap: () => setState(() => _photoCount++),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: AppColors.border,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconMD),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Photos', style: AppTextStyles.bodyMedium),
                    Text(
                      'Tap to attach images from camera or gallery',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              if (_photoCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusChip),
                  ),
                  child: Text(
                    '$_photoCount',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD +
            MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Report Delay — prominent, full width, separate ──
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: OutlinedButton.icon(
              onPressed: _showDelayDialog,
              icon: const Icon(Icons.warning_amber_rounded,
                  size: AppDimensions.iconSM),
              label: const Text('Report Delay'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warning,
                side: const BorderSide(color: AppColors.warning, width: 1.5),
                backgroundColor: AppColors.warningLight,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusButton),
                ),
                textStyle: AppTextStyles.button,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          // ── Submit ──
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                disabledBackgroundColor: AppColors.border,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusButton),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnPrimary,
                      ),
                    )
                  : const Text('Submit Status Change'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step Circle ───────────────────────────────────────────────────────────────

class _StepCircle extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;
  final IconData icon;
  final int index;

  const _StepCircle({
    required this.isCompleted,
    required this.isCurrent,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded,
            color: Colors.white, size: 14),
      );
    }

    if (isCurrent) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Icon(icon, color: AppColors.textTertiary, size: 14),
    );
  }
}

// ── Next Status Card ──────────────────────────────────────────────────────────

class _NextStatusCard extends StatelessWidget {
  final _NextStatusOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _NextStatusCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        margin: const EdgeInsets.fromLTRB(
          AppDimensions.paddingMD,
          0,
          AppDimensions.paddingMD,
          AppDimensions.paddingSM,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected
                ? AppDimensions.borderWidthFocused
                : AppDimensions.borderWidth,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: option.iconColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(option.icon,
                  color: option.iconColor, size: AppDimensions.iconMD),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: AppDimensions.animNormal,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Delay Bottom Sheet ────────────────────────────────────────────────────────

class _DelayBottomSheet extends StatefulWidget {
  final void Function(String reason) onSubmit;

  const _DelayBottomSheet({required this.onSubmit});

  @override
  State<_DelayBottomSheet> createState() => _DelayBottomSheetState();
}

class _DelayBottomSheetState extends State<_DelayBottomSheet> {
  String? _selectedReason;
  final TextEditingController _otherController = TextEditingController();

  static const _reasons = [
    'Awaiting spare parts',
    'Awaiting PTW / permit',
    'Client not available',
    'Safety clearance pending',
    'Traffic / travel delay',
    'Awaiting additional manpower',
    'Other',
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusCard),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: AppDimensions.iconMD),
              const SizedBox(width: 8),
              Text('Report Delay', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Select the reason for the delay',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          ..._reasons.map((reason) {
            final isSelected = _selectedReason == reason;
            return GestureDetector(
              onTap: () => setState(() => _selectedReason = reason),
              child: AnimatedContainer(
                duration: AppDimensions.animNormal,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warningLight
                      : AppColors.surfaceAlt,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusButton),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.warning
                        : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        reason,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? const Color(0xFF92400E)
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_rounded,
                          color: AppColors.warning, size: 16),
                  ],
                ),
              ),
            );
          }),
          if (_selectedReason == 'Other') ...[
            TextField(
              controller: _otherController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Describe the delay reason…',
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: AppColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide:
                      const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide:
                      const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide: const BorderSide(
                      color: AppColors.borderFocused, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: _selectedReason != null
                  ? () => widget.onSubmit(
                        _selectedReason == 'Other'
                            ? _otherController.text.isNotEmpty
                                ? _otherController.text
                                : 'Other'
                            : _selectedReason!,
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusButton),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: const Text('Submit Delay Report'),
            ),
          ),
        ],
      ),
    );
  }
}
