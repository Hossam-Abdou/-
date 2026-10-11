import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/shared/widgets/section_card.dart';
import 'benefit_item.dart';
import '../../../generated/locale_keys.g.dart';

class BenefitsCard extends StatelessWidget {
  const BenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          BenefitItem(
            icon: Icons.rocket_launch_outlined,
            title: LocaleKeys.benefit1Title.tr(),
            description: LocaleKeys.benefit1Desc.tr(),
          ),
          const SizedBox(height: 16),
          BenefitItem(
            icon: Icons.support_agent_outlined,
            title: LocaleKeys.benefit2Title.tr(),
            description: LocaleKeys.benefit2Desc.tr(),
          ),
          const SizedBox(height: 16),
          BenefitItem(
            icon: Icons.verified_outlined,
            title: LocaleKeys.benefit3Title.tr(),
            description: LocaleKeys.benefit3Desc.tr(),
          ),
        ],
      ),
    );
  }
}
