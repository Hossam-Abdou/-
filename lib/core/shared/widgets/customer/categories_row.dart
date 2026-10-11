import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/customer/home/widgets/category_chip.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
class CategoriesRow extends StatelessWidget {
  final ValueChanged<String> onCategoryTap;
  const CategoriesRow({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final categories = [
      (Icons.business_outlined, LocaleKeys.categoryOffice.tr()),
      (Icons.terrain_outlined, LocaleKeys.categoryLand.tr()),
      (Icons.hotel_outlined, LocaleKeys.categoryStudio.tr()),
      (Icons.villa_outlined, LocaleKeys.categoryVilla.tr()),
      (Icons.apartment_outlined, LocaleKeys.categoryApartment.tr()),
    ];

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final (icon, label) = categories[index];
          // Tapping a category jumps straight to search pre-filtered
          // by it, instead of doing nothing as before.
          return CategoryChip(icon: icon, label: label, onTap: () => onCategoryTap(label));
        },
      ),
    );
  }
}
