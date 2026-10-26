import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// One selectable row inside the location sheet.
class LocationRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const LocationRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: icon == null ? null : Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.textSecondary),
        title: Text(
          label,
          style: AppTextStyles.bodyRegular.copyWith(
            color: selected ? AppColors.primaryDark : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: selected ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20) : null,
        onTap: onTap,
      ),
    );
  }
}
