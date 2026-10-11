import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'buttons/app_primary_button.dart';

/// A bottom-pinned bar with a primary button and optional footnote text.
/// Used on the subscriptions screen, and reusable for any screen that
/// needs a persistent CTA (create request, submit offer, etc.).
class StickyBottomBar extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? footnote;
  final bool isLoading;

  const StickyBottomBar({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    this.icon,
    this.footnote,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPrimaryButton(
              label: buttonLabel,
              onPressed: onPressed,
              icon: icon,
              isLoading: isLoading,
            ),
            if (footnote != null) ...[
              const SizedBox(height: 8),
              Text(footnote!, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
