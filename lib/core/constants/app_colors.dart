import 'package:flutter/material.dart';

/// Application color constants
class AppColors {
  AppColors._();

  // Primary colors
  static const Color background = Color(0xFF161622);
  static const Color primary = Color(0xFFFF6B35);
  static const Color secondary = Colors.deepPurple;

  // Status colors
  static const Color liveRed = Color(0xFFFF4D4D);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF757575);

  // UI colors
  static const Color cardBackground = Color(0xFF1E1E2E);
  static const Color divider = Color(0xFF2A2A3A);
  static const Color borderColor = Color(0xFF3A3A4A);

  // Glassmorphism
  static Color glassMorphismBackground = Colors.white.withValues(alpha: 0.1);
  static Color glassMorphismBorder = Colors.white.withValues(alpha: 0.2);

  // Overlay
  static Color overlay = Colors.black.withValues(alpha: 0.6);
  static Color overlayLight = Colors.black.withValues(alpha: 0.3);
}
