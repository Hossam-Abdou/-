import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final String searchText;
  const CustomSearchBar({required this.onTap,required this.searchText});

  @override
  Widget build(BuildContext context) {
    // Opens the dedicated SearchScreen rather than filtering in place —
    // matches searchPlaceholder's copy ("search by city, area, or
    // property type") which needs its own text field and results list.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  searchText,
                  style: AppTextStyles.bodyRegular,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
