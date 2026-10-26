import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/section_card.dart';
import '../../../../core/shared/widgets/skeleton_list.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/offer_preview.dart';
import 'request_offer_card.dart';

/// "Offers received" on the request details: counter, then the offers
/// (skeleton while loading, a note when there are none).
class RequestOffersSection extends StatelessWidget {
  final int count;
  final List<OfferPreview> offers;
  final bool loading;
  const RequestOffersSection({super.key, required this.count, required this.offers, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6)),
              child: Text('$count', style: AppTextStyles.heading4),
            ),
            const SizedBox(width: 8),
            Text(LocaleKeys.viewReceivedOffers.tr(), style: AppTextStyles.heading4),
          ],
        ),
        const SizedBox(height: 16),
        if (loading)
          const SkeletonList(count: 2)
        else if (offers.isEmpty)
          SectionCard(child: Text(LocaleKeys.noOffersYet.tr(), style: AppTextStyles.bodyRegular, textAlign: TextAlign.center))
        else
          for (final o in offers) Padding(padding: const EdgeInsets.only(bottom: 12), child: RequestOfferCard(offer: o)),
      ],
    );
  }
}
