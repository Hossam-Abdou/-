import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../profile/cubit/profile_cubit.dart';
import '../../../listings/cubit/listings_cubit.dart';
import '../../../offers/cubit/offers_cubit.dart';
import '../../../requests/cubit/requests_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/shared/widgets/language_selector_sheet.dart';
import '../../../../core/shared/cubit/locale_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../customer/profile/widgets/profile_menu_item.dart';

/// Content for the marketer "Profile" tab only — no Scaffold/AppBar/
/// bottom nav here, [MarketerShellScreen] owns those.
///
/// Deliberately a different layout from the client ProfileScreen —
/// ratings, stats, and an upgrade card that the client flow doesn't
/// have — matching how the two are genuinely different in Figma.
class MarketerProfileScreen extends StatelessWidget {
  const MarketerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const _MarketerProfileHeader(),
          const SizedBox(height: 16),
          const _StatsRow(),
          const SizedBox(height: 16),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: LocaleKeys.profileMyInfoTitle.tr(),
                  iconInCircle: false,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.marketerMyInformation),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.home_work_outlined,
                  title: LocaleKeys.profileMyListings.tr(),
                  iconInCircle: false,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.marketerProperties),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(icon: Icons.help_outline, title: LocaleKeys.profileHelpCenter.tr(), iconInCircle: false),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.language,
                  title: LocaleKeys.profileLanguageTitle.tr(),
                  subtitle: context.watch<LocaleCubit>().state.languageCode == 'ar' ? 'العربية' : 'English',
                  iconInCircle: false,
                  onTap: () => showLanguageSelector(context),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: LocaleKeys.profileAboutUs.tr(),
                  iconInCircle: false,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _UpgradeCard(onTap: () => Navigator.pushNamed(context, AppRoutes.upgrade)),
          const SizedBox(height: 16),
          // Bordered logout button — matches the Figma design for the
          // marketer flow, distinct from the client's plain text link.
          OutlinedButton.icon(
            onPressed: () async {
              final nav = Navigator.of(context);
              final favorites = context.read<FavoritesCubit>();
              final requests = context.read<RequestsCubit>();
              final offers = context.read<OffersCubit>();
              final mine = context.read<MyListingsCubit>();
              final profile = context.read<ProfileCubit>();
              await AuthRepository().logout();
              favorites.clear();
              requests.clear();
              offers.clear();
              mine.clear();
              profile.clear();
              nav.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(LocaleKeys.profileLogout.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MarketerProfileHeader extends StatefulWidget {
  const _MarketerProfileHeader();

  @override
  State<_MarketerProfileHeader> createState() => _MarketerProfileHeaderState();
}

class _MarketerProfileHeaderState extends State<_MarketerProfileHeader> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().load();
    context.read<MyListingsCubit>().load(); // numbers in the stats row
    context.read<OffersCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().state.selected;
    final avatar = profile?.avatarUrl;
    return Skeletonizer(
      enabled: profile == null,
      child: SectionCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 4),
                  boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 2, offset: Offset(0, 1))],
                ),
                clipBehavior: Clip.antiAlias,
                child: (avatar != null && avatar.isNotEmpty)
                    ? Image.network(avatar, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 44, color: AppColors.primaryDark))
                    : const Icon(Icons.person, size: 44, color: AppColors.primaryDark),
              ),
              PositionedDirectional(
                bottom: 0,
                start: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text((profile?.fullName.isNotEmpty ?? false) ? profile!.fullName : 'Loading name', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 15, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(LocaleKeys.profileRatingLabel.tr(args: [(profile?.rating ?? 0).toStringAsFixed(1), '${profile?.reviewsCount ?? 0}']), style: AppTextStyles.bodyRegular),
            ],
          ),
        ],
      ),
    ));
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final listingsState = context.watch<MyListingsCubit>().state;
    final listings = listingsState.items.length;
    final offersState = context.watch<OffersCubit>().state;
    final offers = offersState.items;
    final loading = (listingsState.isLoading && listings == 0) || (offersState.isLoading && offers.isEmpty);
    final accepted = offers.where((o) => o.status == 'accepted').length;
    return Skeletonizer(
      enabled: loading,
      child: Row(
      children: [
        Expanded(child: _StatCard(value: '$listings', label: LocaleKeys.profileListingsLabel.tr())),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '${offers.length}', label: LocaleKeys.profileOffersSentLabel.tr())),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '$accepted', label: LocaleKeys.profileDealsClosedLabel.tr())),
      ],
    ));
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.priceLarge),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  final VoidCallback onTap;
  const _UpgradeCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(LocaleKeys.profileUpgradePlanTitle.tr(), style: AppTextStyles.heading3.copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.profileUpgradePlanDesc.tr(),
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(LocaleKeys.profileUpgradeNow.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
