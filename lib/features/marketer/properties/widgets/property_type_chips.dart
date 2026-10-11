import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// The property types a marketer can pick from when adding/editing a
/// listing. Kept as plain Arabic strings (not localized) since these
/// are the actual data values stored on a [MarketerProperty] — same
/// convention as [PropertyRequest.propertyType] elsewhere in the app.
const List<String> propertyTypeOptions = ['شقة', 'فيلا', 'دوبلكس', 'استوديو', 'مكتب', 'أرض'];

class PropertyTypeChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PropertyTypeChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(LocaleKeys.propertyTypeLabel.tr(), style: AppTextStyles.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: propertyTypeOptions.map((type) {
            final isSelected = type == selected;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => onChanged(type),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: AppTextStyles.bodySmall.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary),
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
