import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Wrapped in its own Material so the InkWell ripple always has an
    // ancestor to paint on, regardless of what wraps this chip
    // (IndexedStack tabs, dialogs, etc.) — fixes "No Material widget
    // found" for this widget.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 24),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 64,
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
