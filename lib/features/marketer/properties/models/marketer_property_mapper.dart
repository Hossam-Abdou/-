import 'package:easy_localization/easy_localization.dart';

import '../../../listings/models/listing_model.dart';
import 'marketer_property.dart';

/// Shapes a backend [ListingModel] into the [MarketerProperty] the
/// marketer cards use.
extension MarketerPropertyPreview on ListingModel {
  MarketerProperty toMarketerProperty(String lang) {
    final nf = NumberFormat.decimalPattern('en');
    final p = displayPrice;
    return MarketerProperty(
      id: id,
      title: title,
      propertyType: propertyType ?? '',
      location: location(lang),
      areaLabel: area == null ? '' : '${nf.format(area)} م²',
      priceLabel: p == null ? '' : '${nf.format(p)} ج.م',
      isPublished: isPublished,
      imagePaths: [
        if (images.isNotEmpty) ...images else if (coverImageUrl != null) coverImageUrl!,
      ],
    );
  }
}
