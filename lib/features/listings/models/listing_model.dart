import '../../../core/utils/json_utils.dart';
import '../../profile/models/profile_model.dart';

class ListingModel {
  final String id;
  final String? referenceCode;
  final String marketerId;
  final String title;
  final String? listingType; // sale | rent
  final String? category;
  final String? propertyType;
  final String? furnishing;
  final String? finishing;
  final int? cityId;
  final String? cityNameAr;
  final String? cityNameEn;
  final int? districtId;
  final String? districtNameAr;
  final String? districtNameEn;
  final String? street;
  final String? compound;
  final int? floor;
  final double? area;
  final int? rooms;
  final int? bathrooms;
  final double? price;
  final double? rentMonthly;
  final double? rentDaily;
  final int? leaseDurationMonths;
  final List<String> features;
  final String? contactTime;
  final String? description;
  final String status;
  final bool isPublished; // false = hidden from other users
  final DateTime? createdAt;
  final String? coverImageUrl;
  final List<String> images; // details only
  final ProfileModel? marketer;

  const ListingModel({
    required this.id,
    required this.marketerId,
    required this.title,
    this.referenceCode,
    this.listingType,
    this.category,
    this.propertyType,
    this.furnishing,
    this.finishing,
    this.cityId,
    this.cityNameAr,
    this.cityNameEn,
    this.districtId,
    this.districtNameAr,
    this.districtNameEn,
    this.street,
    this.compound,
    this.floor,
    this.area,
    this.rooms,
    this.bathrooms,
    this.price,
    this.rentMonthly,
    this.rentDaily,
    this.leaseDurationMonths,
    this.features = const [],
    this.contactTime,
    this.description,
    this.status = 'active',
    this.isPublished = true,
    this.createdAt,
    this.coverImageUrl,
    this.images = const [],
    this.marketer,
  });

  bool get isRent => listingType == 'rent';

  /// Price shown on cards: sale price, or the monthly (else daily) rent.
  double? get displayPrice => isRent ? (rentMonthly ?? rentDaily) : price;
  bool get isDailyRent => isRent && rentMonthly == null && rentDaily != null;

  bool get isNew => createdAt != null && DateTime.now().difference(createdAt!).inDays < 3;

  /// "District, City" in the given language code ('ar' / 'en').
  String location(String lang) {
    final ar = lang == 'ar';
    final parts = [ar ? districtNameAr : districtNameEn, ar ? cityNameAr : cityNameEn];
    return parts.whereType<String>().where((e) => e.isNotEmpty).join(ar ? '، ' : ', ');
  }

  /// Reads both shapes the API returns: the flat view row used by the browse
  /// list (`city_name_ar`, `marketer_name`...) and the nested details row
  /// (`city: {...}`, `property_images: [...]`, `marketer: {...}`).
  factory ListingModel.fromJson(Map<String, dynamic> j) {
    final city = j['city'] as Map?;
    final district = j['district'] as Map?;
    final imgs = j['property_images'] is List
        ? [for (final i in j['property_images']) '${(i as Map)['image_url']}']
        : <String>[];
    ProfileModel? marketer;
    if (j['marketer'] is Map) {
      marketer = ProfileModel.fromJson(Map<String, dynamic>.from(j['marketer']));
    } else if (j['marketer_name'] != null) {
      marketer = ProfileModel(
        id: '${j['marketer_id']}',
        role: 'marketer',
        fullName: '${j['marketer_name']}',
        avatarUrl: j['marketer_avatar_url'] as String?,
        rating: toDouble(j['marketer_rating']),
        reviewsCount: toInt(j['marketer_reviews_count']) ?? 0,
      );
    }
    return ListingModel(
      id: '${j['id']}',
      referenceCode: j['reference_code'] as String?,
      marketerId: '${j['marketer_id']}',
      title: '${j['title'] ?? ''}',
      listingType: j['listing_type'] as String?,
      category: j['category'] as String?,
      propertyType: j['property_type'] as String?,
      furnishing: j['furnishing'] as String?,
      finishing: j['finishing'] as String?,
      cityId: toInt(j['city_id']),
      cityNameAr: (j['city_name_ar'] ?? city?['name_ar']) as String?,
      cityNameEn: (j['city_name_en'] ?? city?['name_en']) as String?,
      districtId: toInt(j['district_id']),
      districtNameAr: (j['district_name_ar'] ?? district?['name_ar']) as String?,
      districtNameEn: (j['district_name_en'] ?? district?['name_en']) as String?,
      street: j['street'] as String?,
      compound: j['compound'] as String?,
      floor: toInt(j['floor']),
      area: toDouble(j['area']),
      rooms: toInt(j['rooms']),
      bathrooms: toInt(j['bathrooms']),
      price: toDouble(j['price']),
      rentMonthly: toDouble(j['rent_monthly']),
      rentDaily: toDouble(j['rent_daily']),
      leaseDurationMonths: toInt(j['lease_duration_months']),
      features: toStringList(j['features']),
      contactTime: j['contact_time'] as String?,
      description: j['description'] as String?,
      status: '${j['status'] ?? 'active'}',
      isPublished: j['is_published'] != false,
      createdAt: toDate(j['created_at']),
      coverImageUrl: (j['cover_image_url'] ?? (imgs.isEmpty ? null : imgs.first)) as String?,
      images: imgs,
      marketer: marketer,
    );
  }
}

/// Browse filters. Only the fields that are set are sent.
class ListingFilter {
  final String? q;
  final String? referenceCode;
  final int? cityId;
  final int? districtId;
  final String? propertyType;
  final String? listingType;
  final String? category;
  final String? furnishing;
  final String? finishing;
  final double? minPrice;
  final double? maxPrice;
  final double? minRent;
  final double? maxRent;
  final double? minArea;
  final double? maxArea;
  final int? minRooms;
  final int? minBathrooms;
  final List<String> features;
  final String sort; // newest | price_asc | price_desc | rent_asc | rent_desc

  const ListingFilter({
    this.q,
    this.referenceCode,
    this.cityId,
    this.districtId,
    this.propertyType,
    this.listingType,
    this.category,
    this.furnishing,
    this.finishing,
    this.minPrice,
    this.maxPrice,
    this.minRent,
    this.maxRent,
    this.minArea,
    this.maxArea,
    this.minRooms,
    this.minBathrooms,
    this.features = const [],
    this.sort = 'newest',
  });

  Map<String, String> toQuery() {
    final m = <String, String>{'sort': sort};
    void put(String k, Object? v) {
      if (v != null && '$v'.isNotEmpty) m[k] = '$v';
    }

    put('q', q);
    put('reference_code', referenceCode);
    put('city_id', cityId);
    put('district_id', districtId);
    put('property_type', propertyType);
    put('listing_type', listingType);
    put('category', category);
    put('furnishing', furnishing);
    put('finishing', finishing);
    put('min_price', minPrice);
    put('max_price', maxPrice);
    put('min_rent', minRent);
    put('max_rent', maxRent);
    put('min_area', minArea);
    put('max_area', maxArea);
    put('min_rooms', minRooms);
    put('min_bathrooms', minBathrooms);
    if (features.isNotEmpty) m['features'] = features.join(',');
    return m;
  }
}

/// Body for creating a listing (marketer). Sale needs [price]; rent needs
/// [rentMonthly] (with [leaseDurationMonths]) or [rentDaily].
class ListingInput {
  final String title;
  final String listingType;
  final String? category;
  final String? propertyType;
  final String? furnishing;
  final String? finishing;
  final int? cityId;
  final int? districtId;
  final String? street;
  final String? compound;
  final int? floor;
  final double? area;
  final int? rooms;
  final int? bathrooms;
  final double? price;
  final double? rentMonthly;
  final double? rentDaily;
  final int? leaseDurationMonths;
  final List<String> features;
  final String? contactTime;
  final String? description;
  final bool isPublished;
  final List<String> images; // already uploaded urls

  const ListingInput({
    required this.title,
    required this.listingType,
    this.category,
    this.propertyType,
    this.furnishing,
    this.finishing,
    this.cityId,
    this.districtId,
    this.street,
    this.compound,
    this.floor,
    this.area,
    this.rooms,
    this.bathrooms,
    this.price,
    this.rentMonthly,
    this.rentDaily,
    this.leaseDurationMonths,
    this.features = const [],
    this.contactTime,
    this.description,
    this.isPublished = true,
    this.images = const [],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'is_published': isPublished,
        'listing_type': listingType,
        if (category != null) 'category': category,
        if (propertyType != null) 'property_type': propertyType,
        if (furnishing != null) 'furnishing': furnishing,
        if (finishing != null) 'finishing': finishing,
        if (cityId != null) 'city_id': cityId,
        if (districtId != null) 'district_id': districtId,
        if (street != null) 'street': street,
        if (compound != null) 'compound': compound,
        if (floor != null) 'floor': floor,
        if (area != null) 'area': area,
        if (rooms != null) 'rooms': rooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (price != null) 'price': price,
        if (rentMonthly != null) 'rent_monthly': rentMonthly,
        if (rentDaily != null) 'rent_daily': rentDaily,
        if (leaseDurationMonths != null) 'lease_duration_months': leaseDurationMonths,
        if (features.isNotEmpty) 'features': features,
        if (contactTime != null) 'contact_time': contactTime,
        if (description != null) 'description': description,
        if (images.isNotEmpty) 'images': images,
      };
}
