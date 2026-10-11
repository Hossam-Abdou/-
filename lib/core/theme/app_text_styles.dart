import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles matching the two font families used in the Figma file:
/// - Tajawal: body copy, headings, buttons
/// - Cairo (Bold): prices and small tracked badges
class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.tajawal(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.tajawal(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle heading4 = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyRegular = GoogleFonts.tajawal(
    fontSize: 16,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.tajawal(
    fontSize: 14,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.tajawal(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static TextStyle priceLarge = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle priceStrikethrough = GoogleFonts.tajawal(
    fontSize: 14,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle savingsBadge = GoogleFonts.tajawal(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.savingsBadgeText,
  );

  static TextStyle badgeTracked = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.6,
  );

  static TextStyle button = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );
}
