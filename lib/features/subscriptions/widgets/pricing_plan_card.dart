import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/shared/widgets/section_card.dart';
import '../models/pricing_plan.dart';
import '../../../generated/locale_keys.g.dart';

class PricingPlanCard extends StatelessWidget {
  final PricingPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PricingPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final savings = plan.savingsPercent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SectionCard(
            padding: const EdgeInsets.all(17),
            backgroundColor: isSelected ? AppColors.primaryLight : AppColors.surface,
            borderColor: isSelected ? AppColors.primary : AppColors.border,
            borderWidth: isSelected ? 2 : 1,
            child: Row(
              children: [
                _SelectionCircle(isSelected: isSelected),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(plan.durationLabel, style: AppTextStyles.heading4, textAlign: TextAlign.start),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${plan.price.toStringAsFixed(0)} ${LocaleKeys.currency.tr()}', style: AppTextStyles.priceLarge),
                        const SizedBox(width: 6),
                        Text(
                          LocaleKeys.equivalentPerMonth.tr(args: [plan.monthlyEquivalent.toStringAsFixed(1)]),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    if (plan.originalPrice != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${plan.originalPrice!.toStringAsFixed(0)} ${LocaleKeys.currency.tr()}', style: AppTextStyles.priceStrikethrough),
                          const SizedBox(width: 6),
                          if (savings != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.savingsBadgeBg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(LocaleKeys.savePercent.tr(args: ['$savings']), style: AppTextStyles.savingsBadge),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (plan.isPopular)
            PositionedDirectional(
              top: -12,
              end: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(LocaleKeys.mostPopular.tr(), style: AppTextStyles.badgeTracked),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool isSelected;
  const _SelectionCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.textMuted),
      ),
      child: isSelected ? const Icon(Icons.check, size: 14, color: AppColors.textOnPrimary) : null,
    );
  }
}
