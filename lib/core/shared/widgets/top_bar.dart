import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TopBar extends StatelessWidget {
  /// Text on the location chip (the chosen area) and what happens on tap.
  final String? locationLabel;
  final VoidCallback? onLocationTap;

  const TopBar({super.key, this.locationLabel, this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.greetingHi.tr(), style: AppTextStyles.heading4, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(LocaleKeys.homeSubtitle.tr(), style: AppTextStyles.bodyRegular, overflow: TextOverflow.ellipsis),
          ],
        ),
        InkWell(
          onTap: onLocationTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.expand_more, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(locationLabel ?? LocaleKeys.locationAll.tr(), style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            PositionedDirectional(
              end: -1,
              top: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
