import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/fields/app_select_field.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        AppSelectField<String>(
          value: options.contains(value) ? value : null,
          options: [for (final o in options) SelectOption(o, o)],
          placeholder: placeholder,
          sheetTitle: label,
          enabled: enabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
