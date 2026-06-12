import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _inter = 'Inter';
  static const _mono = 'JetBrainsMono';

  // ── Display ──
  static const display = TextStyle(
    fontFamily: _inter,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ── Headings ──
  static const h1 = TextStyle(
    fontFamily: _inter,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const h2 = TextStyle(
    fontFamily: _inter,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontFamily: _inter,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // ── Body ──
  static const body = TextStyle(
    fontFamily: _inter,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _inter,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: _inter,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Caption ──
  static const caption = TextStyle(
    fontFamily: _inter,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── Overline (Section Labels) ──
  static const overline = TextStyle(
    fontFamily: _inter,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // ── Monospace (WO numbers, timers, codes) ──
  static const mono = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const monoLarge = TextStyle(
    fontFamily: _mono,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Button ──
  static const button = TextStyle(
    fontFamily: _inter,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const buttonSmall = TextStyle(
    fontFamily: _inter,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
