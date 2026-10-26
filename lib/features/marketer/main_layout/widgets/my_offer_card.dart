import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/date_time_label.dart';
import '../../../../core/shared/widgets/property_image_strip.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../customer/home/models/offer_preview.dart';
import '../../../customer/home/widgets/offer_status_badge.dart';
import '../../../offers/models/offer_model.dart';

/// The offer this marketer sent on a request: status, when it was sent, the
/// message, the property and its photos.
class MyOfferCard extends StatelessWidget {
  final OfferModel offer;
  const MyOfferCard({super.key, required this.offer});

  OfferStatus get _status => switch (offer.status) {
        'accepted' => OfferStatus.accepted,
        'declined' => OfferStatus.declined,
        _ => OfferStatus.pending,
      };

  @override
  Widget build(BuildContext context) {
    final message = offer.message ?? '';
    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(LocaleKeys.myOfferTitle.tr(), style: AppTextStyles.heading4),
              const Spacer(),
              OfferStatusBadge(status: _status),
            ],
          ),
          if (offer.createdAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${LocaleKeys.offerSentAtLabel.tr()}  ', style: AppTextStyles.caption),
                DateTimeLabel(date: offer.createdAt),
              ],
            ),
          ],
          if (message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(message, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.start),
          ],
          if (offer.propertyTitle != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_work_outlined, size: 16, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          offer.propertyTitle!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (offer.images.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    PropertyImageStrip(imagePaths: offer.images, thumbnailSize: 72),
                  ],
                ],
              ),
            ),
          ] else if (offer.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            PropertyImageStrip(imagePaths: offer.images, thumbnailSize: 72),
          ],
        ],
      ),
    );
  }
}
