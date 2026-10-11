import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/cubit/bottom_bar_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../main_layout/models/marketer_request.dart';
import '../../main_layout/widgets/marketer_request_card.dart';

/// Content for the marketer "Home" tab — a quick dashboard (stats +
/// top matches + shortcuts), separate from the "Requests" tab which
/// is the full browsable list of every client request. Home answers
/// "how am I doing today", Requests answers "what can I respond to".
class MarketerHomeScreen extends StatelessWidget {
  const MarketerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Home shows every available request, including ones already
    // offered on (status is shown via the badge on each card) —
    // it's the full browse feed. The "Requests" tab is the filtered
    // view of only what this marketer has personally engaged with.
    final allRequests = mockMarketerRequests;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _Header(),
          const SizedBox(height: 20),
          const _StatsRow(),
          const SizedBox(height: 20),
          _QuickActionsRow(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => BottomBarCubit.get(context).changeIndex(1),
                child: Text(LocaleKeys.viewAll.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark)),
              ),
              Text(LocaleKeys.recentRequestsTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.start),
            ],
          ),
          const SizedBox(height: 16),
          if (allRequests.isEmpty)
            SectionCard(
              child: Text(LocaleKeys.noNewMatchesDesc.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center),
            )
          else
            ...allRequests.map(
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.greetingHi.tr(), style: AppTextStyles.heading4, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(LocaleKeys.marketerHomeSubtitle.tr(), style: AppTextStyles.bodyRegular, overflow: TextOverflow.ellipsis),
          ],
        ),
        const SizedBox(width: 8),
        Badge(
          child: IconButton(
        icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary),
    onPressed: () => Navigator.pushNamed(context, AppRoutes.marketerNotifications),
        ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    // Demo copy — will come from the account after the backend is wired up.
    final newMatches = mockMarketerRequests.where((r) => r.status == MarketerRequestStatus.none).length;
    return Row(
      children: [
        Expanded(child: _StatCard(value: '$newMatches', label: LocaleKeys.statNewMatches.tr(), icon: Icons.new_releases_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '45', label: LocaleKeys.profileOffersSentLabel.tr(), icon: Icons.send_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '12', label: LocaleKeys.profileDealsClosedLabel.tr(), icon: Icons.handshake_outlined)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatCard({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.priceLarge),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, VoidCallback)> actions = [
      (
        Icons.home_work_outlined,
        LocaleKeys.myPropertiesTitle.tr(),
        () {
          Navigator.pushNamed(context, AppRoutes.marketerProperties);
        },
      ),
      (
        Icons.local_offer_outlined,
        LocaleKeys.quickActionMyOffers.tr(),
        () {
          Navigator.pushNamed(context, AppRoutes.marketerOffers);
        },
      ),
      (
        Icons.person_outline,
        LocaleKeys.quickActionMyProfile.tr(),
        () {
          BottomBarCubit.get(context).changeIndex(4);
        },
      ),
    ];
    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickAction(icon: a.$1, label: a.$2, onTap: a.$3),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primaryDark, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
