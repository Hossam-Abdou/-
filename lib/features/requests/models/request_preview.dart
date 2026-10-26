import 'package:easy_localization/easy_localization.dart';

import '../../customer/home/models/property_request.dart';
import 'request_model.dart';

/// Shapes a backend [RequestModel] into the [PropertyRequest] the existing
/// request cards / details / edit screens already use.
extension RequestPreview on RequestModel {
  PropertyRequest toPreview() {
    final nf = NumberFormat.decimalPattern('en');
    String range(double? a, double? b, String suffix) {
      if (a == null && b == null) return '';
      if (a != null && b != null) return '${nf.format(a)} - ${nf.format(b)}$suffix';
      return '${nf.format(a ?? b)}$suffix';
    }

    return PropertyRequest(
      id: id,
      title: title,
      location: [districtNameAr, cityNameAr].whereType<String>().join('\u060c '),
      area: range(areaFrom, areaTo, '\u0645'),
      rooms: rooms ?? 0,
      bathrooms: bathrooms ?? 0,
      priceRange: range(budgetFrom, budgetTo, ' \u062c.\u0645'),
      propertyType: propertyType ?? '',
      finishing: finishing ?? '',
      description: description ?? '',
      isNew: isNew,
      status: switch (status) {
        'closed' => PropertyRequestStatus.closed,
        'offers_received' => PropertyRequestStatus.offersReceived,
        _ => PropertyRequestStatus.open,
      },
      offersCount: offersCount,
      createdAt: createdAt,
    );
  }
}
