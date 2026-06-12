import 'package:flutter/material.dart';

/// Reflexion Technician App color palette.
/// Inspired by Apple HIG clarity and Stripe Dashboard elegance.
/// White backgrounds, dark forest green primary.
abstract final class AppColors {
  // ── Primary Green Scale ──
  static const primary = Color(0xFF1B4332);
  static const primaryLight = Color(0xFF2D6A4F);
  static const primaryDark = Color(0xFF081C15);
  static const accent = Color(0xFF40916C);
  static const primaryMuted = Color(0xFF52B788);

  // ── Surfaces ──
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF8FAF9);
  static const scaffoldBg = Color(0xFFF8FAF9);

  // ── Borders & Dividers ──
  static const border = Color(0xFFE8EEEB);
  static const borderFocused = Color(0xFF1B4332);
  static const divider = Color(0xFFF0F3F1);

  // ── Text ──
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ──
  static const success = Color(0xFF059669);
  static const successLight = Color(0xFFD1FAE5);
  static const warning = Color(0xFFD97706);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFDC2626);
  static const errorLight = Color(0xFFFEE2E2);
  static const info = Color(0xFF2563EB);
  static const infoLight = Color(0xFFDBEAFE);

  // ── Priority Colors ──
  static const p1 = Color(0xFFDC2626);
  static const p2 = Color(0xFFEA580C);
  static const p3 = Color(0xFF2563EB);
  static const p4 = Color(0xFF6B7280);

  // ── Status Badge Colors (bg, text) ──
  static const statusAssignedBg = Color(0xFFE8EEEB);
  static const statusAssignedText = Color(0xFF6B7280);
  static const statusTripStartedBg = Color(0xFFDBEAFE);
  static const statusTripStartedText = Color(0xFF2563EB);
  static const statusSiteAttendedBg = Color(0xFFFEF3C7);
  static const statusSiteAttendedText = Color(0xFFD97706);
  static const statusWorkStartedBg = Color(0xFFD1FAE5);
  static const statusWorkStartedText = Color(0xFF059669);
  static const statusCompletedBg = Color(0xFF1B4332);
  static const statusCompletedText = Color(0xFFFFFFFF);
  static const statusOnHoldBg = Color(0xFFFEE2E2);
  static const statusOnHoldText = Color(0xFFDC2626);
  static const statusDelayedBg = Color(0xFFFEF3C7);
  static const statusDelayedText = Color(0xFFD97706);

  // ── Misc ──
  static const shimmerBase = Color(0xFFE8EEEB);
  static const shimmerHighlight = Color(0xFFF8FAF9);
  static const overlay = Color(0x80000000);
}
