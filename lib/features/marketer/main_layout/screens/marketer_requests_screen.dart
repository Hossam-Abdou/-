import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:property_seeker/core/shared/widgets/fields/custom_search_bar.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../models/marketer_request.dart';
import '../widgets/marketer_request_card.dart';
import '../../../../generated/locale_keys.g.dart';

/// Content for the marketer "Requests" tab only — no Scaffold/AppBar/
/// bottom nav here. [MarketerShellScreen] owns those and swaps this
/// in via BottomBarCubit.
class MarketerRequestsScreen extends StatelessWidget {
  const MarketerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // "Requests" here means MY main_layout — only ones this marketer has
    // already sent an offer on. Browsing the full marketplace happens
    // on the Home tab; this tab is for tracking what's already sent.
    final myOffers = mockMarketerRequests.where((r) => r.status == MarketerRequestStatus.offerSent).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _Header(),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.myOffersHeaderTitle.tr(args: ['${myOffers.length}']),
            style: AppTextStyles.heading2,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 4),
          Text(LocaleKeys.myOffersHeaderSubtitle.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.start),
          const SizedBox(height: 16),
          CustomSearchBar(onTap: () => Navigator.pushNamed(context, AppRoutes.marketerSearch), searchText: LocaleKeys.marketerSearchPlaceholder.tr(),),
          const SizedBox(height: 16),
          if (myOffers.isEmpty)
            SectionCard(
              child: Column(
                children: [
                  Text(LocaleKeys.noSentOffersTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(LocaleKeys.noSentOffersDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
                ],
              ),
            )
          else
            ...myOffers.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MarketerRequestCard(
                  request: r,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.marketerRequestDetails, arguments: r.id),
                  onAction: () => Navigator.pushNamed(context, AppRoutes.marketerSendOffer, arguments: r.id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerNotifications),
            ),
            PositionedDirectional(
              end: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        Expanded(
          child: Text(
            LocaleKeys.appName.tr(),
            style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MarketerSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _MarketerSearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.marketerSearchPlaceholder.tr(),
                  style: AppTextStyles.bodyRegular,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class _FilterChip extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   const _FilterChip({required this.label, this.icon, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(999),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(999),
//             border: Border.all(color: AppColors.border),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(label, style: AppTextStyles.bodySmall),
//               const SizedBox(width: 8),
//               Icon(icon ?? Icons.expand_more, size: 14, color: AppColors.textSecondary),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

