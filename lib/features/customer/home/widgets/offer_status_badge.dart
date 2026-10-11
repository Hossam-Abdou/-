import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';

/// The small pill showing where one specific offer stands (pending /
/// accepted / declined) — distinct from [RequestStatusBadge], which
/// reflects the *request's* overall status across all of its offers.
class OfferStatusBadge extends StatelessWidget {
  final OfferStatus status;

  const OfferStatusBadge({super.key, required this.status});

  ({String label, Color background, Color textColor}) get _info {
    switch (status) {
      case OfferStatus.pending:
        return (label: LocaleKeys.offerStatusPending.tr(), background: AppColors.background, textColor: AppColors.warning);
      case OfferStatus.accepted:
        return (label: LocaleKeys.offerStatusAccepted.tr(), background: AppColors.accentMint, textColor: AppColors.primaryDark);
      case OfferStatus.declined:
        return (label: LocaleKeys.offerStatusDeclined.tr(), background: AppColors.border, textColor: AppColors.textMuted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: info.background, borderRadius: BorderRadius.circular(4)),
      child: Text(info.label, style: AppTextStyles.badgeTracked.copyWith(color: info.textColor, letterSpacing: 0)),
    );
  }
}
