import 'package:easy_localization/easy_localization.dart';

import '../../customer/home/models/offer_preview.dart';
import 'offer_model.dart';

/// Shapes a backend [OfferModel] into the [OfferPreview] the existing
/// offer card / details screens use.
extension OfferPreviewMapper on OfferModel {
  OfferPreview toPreview(String lang) => OfferPreview(
        id: id,
        marketerId: marketerId,
        requestId: requestId,
        marketerName: marketer?.fullName ?? '',
        rating: marketer?.rating ?? 0,
        reviewsCount: marketer?.reviewsCount ?? 0,
        timeAgo: createdAt == null ? '' : DateFormat.MMMd(lang).add_jm().format(createdAt!.toLocal()),
        message: message ?? '',
        status: switch (status) {
          'accepted' => OfferStatus.accepted,
          'declined' => OfferStatus.declined,
          _ => OfferStatus.pending,
        },
        propertyTitle: propertyTitle,
        propertyImagePaths: images,
      );
}
