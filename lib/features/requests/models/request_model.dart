import '../../../core/utils/json_utils.dart';
import '../../offers/models/offer_model.dart';
import '../../profile/models/profile_model.dart';

class RequestModel {
  final String id;
  final String customerId;
  final String title;
  final String? propertyType;
  final int? cityId;
  final String? cityNameAr;
  final String? cityNameEn;
  final int? districtId;
  final String? districtNameAr;
  final String? districtNameEn;
  final String? compound;
  final double? budgetFrom;
  final double? budgetTo;
  final double? areaFrom;
  final double? areaTo;
  final int? rooms;
  final int? bathrooms;
  final String? finishing;
  final String? description;
  final String status; // open | offers_received | closed
  final bool isNew;
  final int offersCount;
  final DateTime? createdAt;
  final ProfileModel? customer; // only on details
  final List<OfferModel> offers; // only on details

  const RequestModel({
    required this.id,
    required this.customerId,
    required this.title,
    this.propertyType,
    this.cityId,
    this.cityNameAr,
    this.cityNameEn,
    this.districtId,
    this.districtNameAr,
    this.districtNameEn,
    this.compound,
    this.budgetFrom,
    this.budgetTo,
    this.areaFrom,
    this.areaTo,
    this.rooms,
    this.bathrooms,
    this.finishing,
    this.description,
    this.status = 'open',
    this.isNew = false,
    this.offersCount = 0,
    this.createdAt,
    this.customer,
    this.offers = const [],
  });

  bool get isClosed => status == 'closed';

  factory RequestModel.fromJson(Map<String, dynamic> j) {
    final city = j['city'] as Map?;
    final district = j['district'] as Map?;
    return RequestModel(
      id: '${j['id']}',
      customerId: '${j['customer_id']}',
      title: '${j['title'] ?? ''}',
      propertyType: j['property_type'] as String?,
      cityId: toInt(j['city_id']),
      cityNameAr: city?['name_ar'] as String?,
      cityNameEn: city?['name_en'] as String?,
      districtId: toInt(j['district_id']),
      districtNameAr: district?['name_ar'] as String?,
      districtNameEn: district?['name_en'] as String?,
      compound: j['compound'] as String?,
      budgetFrom: toDouble(j['budget_from']),
      budgetTo: toDouble(j['budget_to']),
      areaFrom: toDouble(j['area_from']),
      areaTo: toDouble(j['area_to']),
      rooms: toInt(j['rooms']),
      bathrooms: toInt(j['bathrooms']),
      finishing: j['finishing'] as String?,
      description: j['description'] as String?,
      status: '${j['status'] ?? 'open'}',
      isNew: j['is_new'] == true,
      offersCount: toInt(j['offers_count']) ?? 0,
      createdAt: toDate(j['created_at']),
      customer: j['customer'] is Map ? ProfileModel.fromJson(Map<String, dynamic>.from(j['customer'])) : null,
      offers: j['offers'] is List
          ? [for (final o in j['offers']) OfferModel.fromJson(Map<String, dynamic>.from(o))]
          : const [],
    );
  }
}

/// Body for creating / editing a request.
class RequestInput {
  final String title;
  final String? propertyType;
  final int? cityId;
  final int? districtId;
  final String? compound;
  final double? budgetFrom;
  final double? budgetTo;
  final double? areaFrom;
  final double? areaTo;
  final int? rooms;
  final int? bathrooms;
  final String? finishing;
  final String? description;

  const RequestInput({
    required this.title,
    this.propertyType,
    this.cityId,
    this.districtId,
    this.compound,
    this.budgetFrom,
    this.budgetTo,
    this.areaFrom,
    this.areaTo,
    this.rooms,
    this.bathrooms,
    this.finishing,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (propertyType != null) 'property_type': propertyType,
        if (cityId != null) 'city_id': cityId,
        if (districtId != null) 'district_id': districtId,
        if (compound != null) 'compound': compound,
        if (budgetFrom != null) 'budget_from': budgetFrom,
        if (budgetTo != null) 'budget_to': budgetTo,
        if (areaFrom != null) 'area_from': areaFrom,
        if (areaTo != null) 'area_to': areaTo,
        if (rooms != null) 'rooms': rooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (finishing != null) 'finishing': finishing,
        if (description != null) 'description': description,
      };
}
