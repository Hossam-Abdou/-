import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../home/models/property_request.dart';

/// The small pill showing a request's status (open / offers received /
/// closed). Pulled out of `TrackedRequestCard` so `RequestCard` (the
/// Home-tab browsing card) can show the same status its "My Requests"
/// counterpart does, instead of the two drifting out of sync.
class RequestStatusBadge extends StatelessWidget {
  final PropertyRequestStatus status;

  const RequestStatusBadge({super.key, required this.status});

  ({String label, Color background, Color textColor}) get _info {
    switch (status) {
      case PropertyRequestStatus.open:
        return (label: LocaleKeys.statusOpen.tr(), background: AppColors.background, textColor: AppColors.textSecondary);
      case PropertyRequestStatus.offersReceived:
        return (label: LocaleKeys.statusOffersReceived.tr(), background: AppColors.accentMint, textColor: AppColors.primaryDark);
      case PropertyRequestStatus.closed:
        return (label: LocaleKeys.statusClosed.tr(), background: AppColors.border, textColor: AppColors.textMuted);
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

/// The "X عروض" / "لا توجد عروض بعد" row — how many offers a request
/// has received so far. Shared for the same reason as
/// [RequestStatusBadge].
class RequestOffersCountLabel extends StatelessWidget {
  final int offersCount;

  const RequestOffersCountLabel({super.key, required this.offersCount});

  @override
  Widget build(BuildContext context) {
    if (offersCount <= 0) {
      return Text(LocaleKeys.noOffersYet.tr(), style: AppTextStyles.bodySmall);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_offer_outlined, size: 15, color: AppColors.primaryDark),
        const SizedBox(width: 4),
        Text(
          LocaleKeys.offersCountLabel.tr(args: ['$offersCount']),
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
