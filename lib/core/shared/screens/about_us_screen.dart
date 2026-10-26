import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../widgets/buttons/app_back_button.dart';
import '../widgets/section_card.dart';
import '../../../features/auth/widgets/auth_header.dart';


/// "من نحن" — the same About screen for both the customer and
/// marketer profile menus, since it's app-level info rather than
/// role-specific. App name/version are hardcoded for now; swap for
/// `package_info_plus` once that dependency is added so the version
/// stays in sync with `pubspec.yaml` automatically.
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(LocaleKeys.profileAboutUs.tr(), style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Center(
              child: Column(
                children: [
                  const AuthLogo(size: 96),
                  const SizedBox(height: 12),
                  Text(LocaleKeys.appName.tr(), style: AppTextStyles.heading1),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.aboutUsVersionLabel.tr(args: [_appVersion]),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(LocaleKeys.aboutUsTagline.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.start),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys.aboutUsDescription.tr(),
                    style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary, height: 1.6),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.aboutUsFeaturesTitle.tr(), style: AppTextStyles.heading4),
                  const SizedBox(height: 12),
                  _Feature(icon: Icons.edit_note, title: LocaleKeys.aboutUsFeature1Title.tr(), desc: LocaleKeys.aboutUsFeature1Desc.tr()),
                  const SizedBox(height: 12),
                  _Feature(icon: Icons.local_offer_outlined, title: LocaleKeys.aboutUsFeature2Title.tr(), desc: LocaleKeys.aboutUsFeature2Desc.tr()),
                  const SizedBox(height: 12),
                  _Feature(icon: Icons.forum_outlined, title: LocaleKeys.aboutUsFeature3Title.tr(), desc: LocaleKeys.aboutUsFeature3Desc.tr()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoRow(icon: Icons.email_outlined, label: LocaleKeys.aboutUsContactTitle.tr(), value: 'support@propertyseeker.com'),
                  const Divider(height: 1, color: AppColors.border),
                  _InfoRow(icon: Icons.language, label: LocaleKeys.aboutUsWebsiteLabel.tr(), value: 'www.propertyseeker.com'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                LocaleKeys.aboutUsCopyright.tr(args: ['${DateTime.now().year}']),
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.bodySmall),
          const Spacer(),
          Text(value, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary), ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _Feature({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.heading4),
              const SizedBox(height: 2),
              Text(desc, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
