import 'package:flutter/material.dart';

/// Centralized color constants for the Enforsys app design system.
/// All hardcoded color values across the codebase should reference
/// these constants to ensure consistency and easy brand updates.
abstract final class AppColors {
  // ─── Brand / Accent ──────────────────────────────────────────
  static const Color accent = Color(0xFFF5A623);
  static const Color accentDark = Color(0xFFE8941A);

  // ─── Backgrounds ─────────────────────────────────────────────
  static const Color background = Color(0xFFF3F4F6);
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;

  // ─── Text ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF374151);
  static const Color textDarker = Color(0xFF4B5563);
  static const Color textBlack = Color(0xFF111827);

  // ─── Borders & Dividers ──────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color inputHint = Color(0xFFBDBDBD);
  static const Color placeholderHint = Color(0xFFD1D5DB);

  // ─── Semantic Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorLight = Color(0xFFF05252);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
}
