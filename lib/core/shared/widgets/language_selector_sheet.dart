import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../cubit/locale_cubit.dart';

/// Opens the language picker. Picking a language calls
/// [LocaleCubit.changeLocale], which reloads translations, persists
/// the choice for next launch, and (via `MaterialApp.locale` in
/// `main.dart`) flips the whole app between RTL and LTR automatically
/// — no manual direction handling needed here.
Future<void> showLanguageSelector(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) => const _LanguageSelectorSheet(),
  );
}

class _LanguageSelectorSheet extends StatelessWidget {
  const _LanguageSelectorSheet();

  static const _options = [
    (code: 'ar', label: 'العربية'),
    (code: 'en', label: 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentCode = context.watch<LocaleCubit>().state.languageCode;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(LocaleKeys.profileLanguageTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ..._options.map((option) {
              final isSelected = option.code == currentCode;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  await context.read<LocaleCubit>().changeLocale(context, Locale(option.code));
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        size: 20,
                        color: isSelected ? AppColors.primary : AppColors.textMuted,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        option.label,
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
