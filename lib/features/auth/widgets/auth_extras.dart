import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Light-green hint box with the (i) icon.
class AuthInfoBanner extends StatelessWidget {
  const AuthInfoBanner({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, height: 1.6)),
          ),
        ],
      ),
    );
  }
}

/// Checkbox + label (remember-me / accept terms). [errorText] shows under it.
class AuthCheckRow extends StatelessWidget {
  const AuthCheckRow({super.key, required this.value, required this.onChanged, required this.label, this.errorText});
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(!value),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: value,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  side: BorderSide(color: errorText == null ? AppColors.textMuted : AppColors.error, width: 1.4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Padding(padding: const EdgeInsets.only(top: 2), child: Text(label, style: AppTextStyles.bodySmall.copyWith(height: 1.5)))),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 34, top: 4),
            child: Text(errorText!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ),
      ],
    );
  }
}
