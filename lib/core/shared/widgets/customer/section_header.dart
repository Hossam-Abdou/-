import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
class SectionHeader extends StatelessWidget {
  final VoidCallback onViewAllTap;
  /// Defaults to "Recent requests" when null.
  final String? title;
  const SectionHeader({required this.onViewAllTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onViewAllTap,
          child: Text(LocaleKeys.viewAll.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark)),
        ),
        Flexible(
          child: Text(
            title ?? LocaleKeys.recentRequestsTitle.tr(),
            style: AppTextStyles.heading4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
