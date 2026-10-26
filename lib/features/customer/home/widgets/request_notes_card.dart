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

class RequestNotesCard extends StatelessWidget {
  final String description;
  const RequestNotesCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(LocaleKeys.requestDescriptionTitle.tr(), style: AppTextStyles.heading3, textAlign: TextAlign.start),
          const SizedBox(height: 8),
          Text(
            description.isNotEmpty ? description : LocaleKeys.noDescriptionAvailable.tr(),
            style: AppTextStyles.bodyRegular,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
