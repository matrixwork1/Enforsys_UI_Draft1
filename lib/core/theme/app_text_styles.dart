import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable text styles that correspond to common typography patterns
/// found throughout the Enforsys app.
abstract final class AppTextStyles {
  // ─── Headings ────────────────────────────────────────────────
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // ─── Body ────────────────────────────────────────────────────
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // ─── Labels & Captions ───────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // ─── Plate Numbers ───────────────────────────────────────────
  static const TextStyle plateNumber = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle plateNumberLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textBlack,
    letterSpacing: 0.5,
  );

  // ─── Form Hints ──────────────────────────────────────────────
  static const TextStyle hint = TextStyle(
    color: AppColors.inputHint,
    fontStyle: FontStyle.italic,
    fontSize: 13,
  );
}
