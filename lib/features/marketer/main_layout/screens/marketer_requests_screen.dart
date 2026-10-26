import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/skeleton_list.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/marketer_request_mapper.dart';
import 'package:property_seeker/core/shared/widgets/fields/custom_search_bar.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../models/marketer_request.dart';
import '../widgets/marketer_request_card.dart';
import '../widgets/my_offer_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../offers/cubit/offers_cubit.dart';
import '../../../../generated/locale_keys.g.dart';

/// Content for the marketer "Requests" tab only — no Scaffold/AppBar/
/// bottom nav here. [MarketerShellScreen] owns those and swaps this
/// in via BottomBarCubit.
class MarketerRequestsScreen extends StatefulWidget {
  const MarketerRequestsScreen({super.key});

  @override
  State<MarketerRequestsScreen> createState() => _MarketerRequestsScreenState();
}

class _MarketerRequestsScreenState extends State<MarketerRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) loadMarketerRequests(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // "Requests" here means MY offers — only requests this marketer has
    // already sent an offer on. Browsing everything happens on Home.
    return MarketerRequestsBuilder(
      builder: (context, all, loading) {
        final myOffers = all.where((r) => r.status == MarketerRequestStatus.offerSent).toList();
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => loadMarketerRequests(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                CustomSearchBar(onTap: () => Navigator.pushNamed(context, AppRoutes.marketerSearch), searchText: LocaleKeys.marketerSearchPlaceholder.tr()),
                const SizedBox(height: 16),
                if (myOffers.isEmpty && loading)
                  const SkeletonList()
                else if (myOffers.isEmpty)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MarketerRequestCard(
                            request: r,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.marketerRequestDetails, arguments: r.id),
                            onAction: () => Navigator.pushNamed(context, AppRoutes.marketerSendOffer, arguments: r.id),
                          ),
                          for (final o in context.watch<OffersCubit>().state.items.where((o) => o.requestId == r.id).take(1))
                            Padding(padding: const EdgeInsets.only(top: 8), child: MyOfferCard(offer: o)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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

