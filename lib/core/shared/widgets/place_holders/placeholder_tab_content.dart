import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

/// Same "coming soon" message as [PlaceholderScreen], but without its
/// own Scaffold/AppBar — for use as a tab's content inside a shell
/// that already owns the Scaffold and bottom nav bar.
class PlaceholderTabContent extends StatelessWidget {
  final String title;

  const PlaceholderTabContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.heading3, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Icon(Icons.construction_outlined, size: 40),
              const SizedBox(height: 12),
              Text(LocaleKeys.comingSoonTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(LocaleKeys.comingSoonDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
