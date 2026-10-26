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

class RequestOfferCard extends StatelessWidget {
  final OfferPreview offer;
  const RequestOfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pushNamed(context, AppRoutes.offerDetails, arguments: offer.id),
      child: SectionCard(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.person, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(offer.timeAgo, style: AppTextStyles.caption),
                        const Spacer(),
                        Text(offer.marketerName, style: AppTextStyles.heading4),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [OfferStatusBadge(status: offer.status)],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.reviewsCountLabel.tr(args: ['${offer.reviewsCount}']), style: AppTextStyles.caption),
                        const SizedBox(width: 4),
                        Text('${offer.rating}', style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 12, color: AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.message,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (offer.propertyTitle != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_work_outlined, size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          offer.propertyTitle!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Every photo the marketer attached to this property
                  // shows here — not just a cover — and tapping any one
                  // opens the full-screen swipeable gallery.
                  PropertyImageStrip(imagePaths: offer.propertyImagePaths, thumbnailSize: 76),
                ],
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
