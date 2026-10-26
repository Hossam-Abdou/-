import '../utils/json_utils.dart';

/// Fixed cities / districts. The numeric ids are the same ones stored in the
/// database (migration 008_locations_cities_districts.sql) and sent to the
/// API as `city_id` / `district_id`, so the app never sends free text.
class City {
  final int id;
  final String nameAr;
  final String nameEn;
  const City(this.id, this.nameAr, this.nameEn);

  factory City.fromJson(Map<String, dynamic> j) => City(toInt(j['id'])!, '${j['name_ar']}', '${j['name_en']}');

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

class District {
  final int id;
  final int cityId;
  final String nameAr;
  final String nameEn;
  const District(this.id, this.cityId, this.nameAr, this.nameEn);

  factory District.fromJson(Map<String, dynamic> j) =>
      District(toInt(j['id'])!, toInt(j['city_id'])!, '${j['name_ar']}', '${j['name_en']}');

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

class Locations {
  Locations._();

  static const cities = <City>[
    City(1, 'القاهرة', 'Cairo'),
    City(2, 'الجيزة', 'Giza'),
    City(3, 'الإسكندرية', 'Alexandria'),
  ];

  static const districts = <District>[
    // Giza
    District(1, 2, 'الدقي', 'Dokki'),
    District(2, 2, 'المهندسين', 'Mohandessin'),
    District(3, 2, 'العجوزة', 'Agouza'),
    District(4, 2, 'الهرم', 'Haram'),
    District(5, 2, 'فيصل', 'Faisal'),
    District(6, 2, '6 أكتوبر', '6th of October'),
    District(7, 2, 'الشيخ زايد', 'Sheikh Zayed'),
    District(8, 2, 'حدائق الأهرام', 'Hadayek El Ahram'),
    // Cairo
    District(9, 1, 'مدينة نصر', 'Nasr City'),
    District(10, 1, 'مصر الجديدة', 'Heliopolis'),
    District(11, 1, 'المعادي', 'Maadi'),
    District(12, 1, 'التجمع الخامس', 'Fifth Settlement'),
    District(13, 1, 'القاهرة الجديدة', 'New Cairo'),
    District(14, 1, 'الزمالك', 'Zamalek'),
    District(15, 1, 'وسط البلد', 'Downtown'),
    District(16, 1, 'المقطم', 'Mokattam'),
    District(17, 1, 'شبرا', 'Shubra'),
    District(18, 1, 'مدينتي', 'Madinaty'),
    District(19, 1, 'الرحاب', 'El Rehab'),
    District(20, 1, 'الشروق', 'El Shorouk'),
    // Alexandria
    District(21, 3, 'سموحة', 'Smouha'),
    District(22, 3, 'سيدي جابر', 'Sidi Gaber'),
    District(23, 3, 'ميامي', 'Miami'),
    District(24, 3, 'ستانلي', 'Stanley'),
    District(25, 3, 'المنتزه', 'Montaza'),
    District(26, 3, 'رشدي', 'Roushdy'),
    District(27, 3, 'جليم', 'Gleem'),
    District(28, 3, 'العجمي', 'Agami'),
  ];

  static List<District> districtsOf(int cityId) =>
      districts.where((d) => d.cityId == cityId).toList();
}
