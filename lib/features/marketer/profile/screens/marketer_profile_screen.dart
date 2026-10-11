import 'package:flutter/material.dart';
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
            onPressed: () {
              // TODO: wire up once auth/session handling is decided.
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

class _MarketerProfileHeader extends StatelessWidget {
  const _MarketerProfileHeader();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
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
                child: const Icon(Icons.person, size: 44, color: AppColors.primaryDark),
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
          // Demo copy — will come from the account after login is wired up.
           Text('أحمد محمود', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 15, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(LocaleKeys.profileRatingLabel.tr(args: ['4.8', '120']), style: AppTextStyles.bodyRegular),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    // Demo copy — will come from the account after the backend is wired up.
    return Row(
      children: [
        Expanded(child: _StatCard(value: '8', label: LocaleKeys.profileListingsLabel.tr())),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '45', label: LocaleKeys.profileOffersSentLabel.tr())),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(value: '12', label: LocaleKeys.profileDealsClosedLabel.tr())),
      ],
    );
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
