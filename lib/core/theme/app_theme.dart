import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Builds the centralized ThemeData for the Enforsys app.
/// Previously inline inside main.dart's MaterialApp.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
      textTheme: GoogleFonts.interTextTheme(),
    );
  }
}
