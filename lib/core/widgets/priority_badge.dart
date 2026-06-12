import 'package:flutter/material.dart';
import '../../config/constants/enums.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class PriorityBadge extends StatelessWidget {
  final Priority priority;
  final bool compact;

  const PriorityBadge({super.key, required this.priority, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final color = _color;
    if (compact) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          priority.label,
          style: AppTextStyles.caption.copyWith(
            color: priority == Priority.p4 ? AppColors.textSecondary : Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.label,
        style: AppTextStyles.caption.copyWith(
          color: priority == Priority.p4 ? AppColors.textSecondary : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'JetBrainsMono',
        ),
      ),
    );
  }

  Color get _color => switch (priority) {
    Priority.p1 => AppColors.p1,
    Priority.p2 => AppColors.p2,
    Priority.p3 => AppColors.p3,
    Priority.p4 => AppColors.border,
  };
}
