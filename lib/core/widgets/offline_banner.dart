import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final bool isSyncing;

  const OfflineBanner({
    super.key,
    required this.isOffline,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      offset: isOffline ? Offset.zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isOffline ? 1.0 : 0.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isSyncing ? AppColors.infoLight : AppColors.warningLight,
          child: Row(
            children: [
              if (isSyncing)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.info,
                  ),
                )
              else
                Icon(
                  Icons.cloud_off_rounded,
                  size: 16,
                  color: isSyncing ? AppColors.info : AppColors.warning,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSyncing
                      ? 'Syncing changes...'
                      : 'You are offline. Changes will sync when connected.',
                  style: AppTextStyles.caption.copyWith(
                    color: isSyncing ? AppColors.info : AppColors.warning,
                    fontWeight: FontWeight.w600,
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
