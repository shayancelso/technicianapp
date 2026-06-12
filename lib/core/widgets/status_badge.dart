import 'package:flutter/material.dart';
import '../../config/constants/enums.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final WOStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, text) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(
          color: text,
          fontWeight: FontWeight.w600,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  (Color bg, Color text) get _colors => switch (status) {
    WOStatus.assigned => (AppColors.statusAssignedBg, AppColors.statusAssignedText),
    WOStatus.tripStarted => (AppColors.statusTripStartedBg, AppColors.statusTripStartedText),
    WOStatus.siteAttended => (AppColors.statusSiteAttendedBg, AppColors.statusSiteAttendedText),
    WOStatus.workStarted => (AppColors.statusWorkStartedBg, AppColors.statusWorkStartedText),
    WOStatus.workCompleted => (AppColors.statusCompletedBg, AppColors.statusCompletedText),
    WOStatus.onHold || WOStatus.outOfScopeDeclined => (AppColors.statusOnHoldBg, AppColors.statusOnHoldText),
    WOStatus.delayed || WOStatus.customerNotResponding || WOStatus.customerDeferred || WOStatus.customerNotAvailable || WOStatus.securityAccessIssue => (AppColors.statusDelayedBg, AppColors.statusDelayedText),
    _ => (AppColors.statusAssignedBg, AppColors.statusAssignedText),
  };
}
