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
import '../widgets/profile_menu_item.dart';

/// Content for the client "Profile" tab only — no Scaffold/bottom nav
/// here, [ClientShellScreen] owns those.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const _ProfileHeader(),
          const SizedBox(height: 24),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: LocaleKeys.profileMyInfoTitle.tr(),
                  subtitle: LocaleKeys.profileMyInfoDesc.tr(),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.myInformation),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: LocaleKeys.profilePaymentTitle.tr(),
                  subtitle: LocaleKeys.profilePaymentDesc.tr(),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.favorite_border,
                  title: LocaleKeys.profileFavoritesTitle.tr(),
                  subtitle: LocaleKeys.profileFavoritesDesc.tr(),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.bookmark_border,
                  title: LocaleKeys.profileSavedSearchesTitle.tr(),
                  subtitle: LocaleKeys.profileSavedSearchesDesc.tr(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.person_add_alt_outlined,
                  title: LocaleKeys.profileInviteFriends.tr(),
                  iconInCircle: false,
                ),
                const Divider(height: 1, color: AppColors.border),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: LocaleKeys.profileHelpCenter.tr(),
                  iconInCircle: false,
                ),
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
          // Plain text-style logout (no border) — matches the Figma design
          // for the client flow, distinct from the marketer's bordered button.
          TextButton.icon(
            onPressed: () {
              // TODO: wire up once auth/session handling is decided.
            },
            icon: const Icon(Icons.logout, size: 18, color: AppColors.error),
            label: Text(LocaleKeys.profileLogout.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withOpacity(0.05), AppColors.surface],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 4),
              boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: const Icon(Icons.person, size: 44, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 12),
          // Demo copy — will come from the account after login is wired up.
           Text('سارة أحمد', style: AppTextStyles.heading1, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 16, color: AppColors.accentMint),
              const SizedBox(width: 4),
              Text(LocaleKeys.profileSeekerLabel.tr(), style: AppTextStyles.bodyRegular),
            ],
          ),
        ],
      ),
    );
  }
}
