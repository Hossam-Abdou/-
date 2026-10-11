import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class DetailSpec extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const DetailSpec({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryDark),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.heading4, textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String label;
  final Color background;
  final Color? textColor;
  final bool bordered;

  const Tag({required this.label, required this.background, this.textColor, this.bordered = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: bordered ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.badgeTracked.copyWith(color: textColor ?? AppColors.textPrimary, letterSpacing: 0),
      ),
    );
  }
}