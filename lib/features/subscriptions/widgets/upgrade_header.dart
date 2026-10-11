import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';

class UpgradeHeader extends StatelessWidget {
  const UpgradeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          child: const Icon(Icons.workspace_premium, color: AppColors.primaryDark, size: 30),
        ),
        const SizedBox(height: 12),
        Text(LocaleKeys.upgradeTitle.tr(), style: AppTextStyles.heading1, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(LocaleKeys.upgradeSubtitle.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
      ],
    );
  }
}
