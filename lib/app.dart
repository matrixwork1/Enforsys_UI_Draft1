import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'widgets/elderly_keyboard/elderly_keyboard_scaffold.dart';

/// Root application widget extracted from main.dart.
class EnforsysApp extends StatelessWidget {
  const EnforsysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enforsys App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        // Wrap the entire app with the elderly keyboard scaffold
        // so the custom keyboard overlay is available on all screens
        return ElderlyKeyboardScaffold(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LoginScreen(),
    );
  }
}
