import 'package:easy_localization/easy_localization.dart';

import '../../../../core/data/locations.dart';
import '../../../../generated/locale_keys.g.dart';

/// Text for the location chip: the district, else the city, else "all areas".
String locationLabel({int? cityId, int? districtId, required bool isArabic}) {
  if (districtId != null) {
    final d = Locations.districts.firstWhere((d) => d.id == districtId);
    return isArabic ? d.nameAr : d.nameEn;
  }
  if (cityId != null) {
    final c = Locations.cities.firstWhere((c) => c.id == cityId);
    return isArabic ? c.nameAr : c.nameEn;
  }
  return LocaleKeys.locationAll.tr();
}
