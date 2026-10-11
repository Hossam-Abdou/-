import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_text_styles.dart';
import '../buttons/app_back_button.dart';
import '../../../../generated/locale_keys.g.dart';

/// Stand-in for every screen from the Figma file that hasn't been
/// built yet. Wired into the router under its real route/title so
/// navigation across the whole app works today, and each screen gets
/// swapped for its real implementation one at a time without touching
/// the router or any other screen.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), leading: const AppBackButton()),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, size: 40),
              const SizedBox(height: 12),
              Text(LocaleKeys.comingSoonTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(LocaleKeys.comingSoonDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
