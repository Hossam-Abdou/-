import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// "For sale / For rent" selector.
class ListingTypeChips extends StatelessWidget {
  final String value; // sale | rent
  final ValueChanged<String> onChanged;
  const ListingTypeChips({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String v, String label) {
      final selected = value == v;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onChanged(v),
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: selected ? Colors.white : AppColors.textPrimary),
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        showCheckmark: false,
      );
    }

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      children: [
        chip('sale', LocaleKeys.listingForSale.tr()),
        chip('rent', LocaleKeys.listingForRent.tr()),
      ],
    );
  }
}
