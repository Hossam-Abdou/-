import '../../../listings/models/listing_model.dart';

/// The values of the add / edit property form. The form widgets write into it
/// as the user types or picks, and the save button turns it into the request
/// body. Plain data, no Flutter and no cubit.
class PropertyDraft {
  String title;
  String propertyType; // شقة / فيلا ...
  String listingType; // sale | rent
  int? cityId;
  int? districtId;
  String area;
  String price; // sale price, or the monthly rent
  String leaseMonths; // rent only
  String rooms;
  String bathrooms;
  String description;
  bool isPublished;

  /// Photos: local file paths and / or http(s) links.
  List<String> images;

  /// The links the listing already had (edit mode), so only new photos are added.
  List<String> originalImages;

  PropertyDraft({
    this.title = '',
    this.propertyType = defaultPropertyType,
    this.listingType = 'sale',
    this.cityId,
    this.districtId,
    this.area = '',
    this.price = '',
    this.leaseMonths = '',
    this.rooms = '',
    this.bathrooms = '',
    this.description = '',
    this.isPublished = true,
    List<String>? images,
  })  : images = images ?? [],
        originalImages = List.of(images ?? const []);

  static const defaultPropertyType = 'شقة'; // شقة

  factory PropertyDraft.from(ListingModel? l) {
    if (l == null) return PropertyDraft();
    String num(double? v) => v == null ? '' : (v == v.roundToDouble() ? v.toInt().toString() : v.toString());
    return PropertyDraft(
      title: l.title,
      propertyType: l.propertyType ?? defaultPropertyType,
      listingType: l.listingType ?? 'sale',
      cityId: l.cityId,
      districtId: l.districtId,
      area: num(l.area),
      price: num(l.isRent ? (l.rentMonthly ?? l.rentDaily) : l.price),
      leaseMonths: l.leaseDurationMonths?.toString() ?? '',
      rooms: l.rooms?.toString() ?? '',
      bathrooms: l.bathrooms?.toString() ?? '',
      description: l.description ?? '',
      isPublished: l.isPublished,
      images: [if (l.images.isNotEmpty) ...l.images else if (l.coverImageUrl != null) l.coverImageUrl!],
    );
  }

  bool get isRent => listingType == 'rent';

  double? _num(String s) => double.tryParse(s.trim());
  int? _int(String s) => int.tryParse(s.trim());

  /// Body for creating the listing; [imageUrls] are the already uploaded photos.
  ListingInput toInput(List<String> imageUrls) => ListingInput(
        title: title.trim(),
        listingType: listingType,
        propertyType: propertyType,
        cityId: cityId,
        districtId: districtId,
        area: _num(area),
        rooms: _int(rooms),
        bathrooms: _int(bathrooms),
        price: isRent ? null : _num(price),
        rentMonthly: isRent ? _num(price) : null,
        leaseDurationMonths: isRent ? _int(leaseMonths) : null,
        description: description.trim().isEmpty ? null : description.trim(),
        isPublished: isPublished,
        images: imageUrls,
      );

  /// Fields for updating the listing (photos are added separately).
  Map<String, dynamic> toUpdateFields() => {
        'title': title.trim(),
        'property_type': propertyType,
        'listing_type': listingType,
        'city_id': cityId,
        'district_id': districtId,
        'area': _num(area),
        'rooms': _int(rooms),
        'bathrooms': _int(bathrooms),
        'description': description.trim(),
        'is_published': isPublished,
        if (isRent) 'rent_monthly': _num(price) else 'price': _num(price),
        if (isRent) 'lease_duration_months': _int(leaseMonths),
      };
}
