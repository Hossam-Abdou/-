import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

/// Consistent back arrow for every AppBar. `matchTextDirection: true`
/// mirrors the arrow automatically under RTL — no manual direction
/// check needed, and no extra `Directionality` widget either;
/// Flutter already derives the ambient direction from the app's
/// current locale (see `LocaleCubit` / `main.dart`).
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark, ),
      tooltip: LocaleKeys.backButtonLabel.tr(),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}
