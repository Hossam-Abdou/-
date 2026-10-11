import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A dropdown select styled like [AppTextField]/[ValidatedTextField]
/// (same border, radius, and label treatment) so it fits the rest of
/// the form. Used for city/district/compound and for the simple
/// value pickers (rooms, bathrooms, finishing) on the details step.
class LabeledDropdownField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? value;
  final String placeholder;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const LabeledDropdownField({
    super.key,
    required this.label,
    this.icon,
    required this.value,
    required this.placeholder,
    required this.options,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 15, color: AppColors.textSecondary),
            ],
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: options.contains(value) ? value : null,
          isExpanded: true,
          alignment: AlignmentDirectional.centerEnd,
          onChanged: enabled ? onChanged : null,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          disabledHint: Text(placeholder, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textMuted), textAlign: TextAlign.start),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          ),
          hint: Text(placeholder, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textMuted), textAlign: TextAlign.start),
          items: options
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.start),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
