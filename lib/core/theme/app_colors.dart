import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
///
/// NOTE: The Figma file used three different greens across screens
/// (#005139, #106b4e, #74fbc2) with no clear system. Here they're
/// consolidated into one brand color with defined roles, so every
/// screen you build reads from the same palette instead of new
/// hex values getting hardcoded per-screen.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0B6E4F); // main brand green (buttons, selected states)
  static const Color primaryDark = Color(0xFF005139); // headings, prices, emphasis text
  static const Color primaryLight = Color(0xFFE6F4EF); // selected-card background tint
  static const Color accentMint = Color(0xFF74FBC2); // active bottom-nav pill only

  // Text
  static const Color textPrimary = Color(0xFF191C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Colors.white;
  static const Color textMuted = Color(0xFF9CA3AF);

  // Surfaces
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB);

  // Status / semantic
  static const Color warning = Color(0xFFF59E0B); // "الأكثر مبيعاً" badge
  static const Color savingsBadgeBg = Color(0xFFDCFCE7);
  static const Color savingsBadgeText = Color(0xFF16A34A);
  static const Color error = Color(0xFFEF4444);

  // Shadows
  static const Color shadow = Color(0x0D000000);
}
