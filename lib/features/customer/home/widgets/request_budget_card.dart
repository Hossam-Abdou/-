import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';
import '../models/property_request.dart';
import 'offer_status_badge.dart';

class RequestBudgetCard extends StatelessWidget {
  final String priceRange;
  const RequestBudgetCard({required this.priceRange});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SectionCard(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Text(LocaleKeys.suggestedBudgetLabel.tr(), style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(priceRange, style: AppTextStyles.priceLarge),
              ],
            ),
          ),
          PositionedDirectional(
            top: -16,
            end: -16,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
