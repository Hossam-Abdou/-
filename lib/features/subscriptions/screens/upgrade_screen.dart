import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../core/shared/widgets/sticky_bottom_bar.dart';
import '../models/pricing_plan.dart';
import '../widgets/benefits_card.dart';
import '../widgets/pricing_plan_card.dart';
import '../widgets/upgrade_header.dart';
import '../../../generated/locale_keys.g.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  // Defaults to the popular plan, mirroring the Figma design.
  String _selectedPlanId = mockPricingPlans.firstWhere((p) => p.isPopular).id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.appName.tr(), style: AppTextStyles.heading4.copyWith(color: AppColors.primaryDark)),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const UpgradeHeader(),
            const SizedBox(height: 24),
            const BenefitsCard(),
            const SizedBox(height: 16),
            ...mockPricingPlans.map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PricingPlanCard(
                  plan: plan,
                  isSelected: _selectedPlanId == plan.id,
                  onTap: () => setState(() => _selectedPlanId = plan.id),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        buttonLabel: LocaleKeys.continueToPayment.tr(),
        icon: Icons.arrow_back,
        footnote: LocaleKeys.termsAgreement.tr(),
        onPressed: () {
          // TODO: wire up once the payment gateway is decided (e.g. Paymob).
        },
      ),
    );
  }
}
