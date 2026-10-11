import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';

/// The property types a marketer or client can pick from (adding a
/// listing, or describing what they're looking for). Kept as plain
/// Arabic strings (not localized) since these are the actual data
/// values stored on [MarketerProperty]/[PropertyRequest] — not UI copy.
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
