/// A property this marketer has listed. Demo copy only — will come
/// from the backend later. This is what gets picked from when
/// sending an offer on a client's request (see SendOfferScreen).
class MarketerProperty {
  final String id;
  final String title;
  final String propertyType;
  final String location;
  final String areaLabel;
  final String priceLabel;

  /// Local file paths of the photos the marketer picked from their
  /// gallery, in the order picked — the first one is the cover photo
  /// shown in lists. Empty if they haven't added any yet. There's no
  /// backend/upload yet, so these stay device-local paths.
  final List<String> imagePaths;

  const MarketerProperty({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.location,
    required this.areaLabel,
    required this.priceLabel,
    this.imagePaths = const [],
  });

  String? get coverImagePath => imagePaths.isNotEmpty ? imagePaths.first : null;

  MarketerProperty copyWith({
    String? title,
    String? propertyType,
    String? location,
    String? areaLabel,
    String? priceLabel,
    List<String>? imagePaths,
  }) {
    return MarketerProperty(
      id: id,
      title: title ?? this.title,
      propertyType: propertyType ?? this.propertyType,
      location: location ?? this.location,
      areaLabel: areaLabel ?? this.areaLabel,
      priceLabel: priceLabel ?? this.priceLabel,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}

/// In-memory only — replace with a repository once the backend and
/// real photo uploads exist. Mutable (not const) so add/edit/delete
/// from [PropertyFormScreen] actually stick for the rest of the
/// session.
final List<MarketerProperty> mockMarketerProperties = [
  const MarketerProperty(
    id: 'prop-1',
    title: 'شقة تشطيب سوبر لوكس',
    propertyType: 'شقة',
    location: 'التجمع الخامس، القاهرة الجديدة',
    areaLabel: '175 م²',
    priceLabel: '3,800,000 ج.م',
  ),
  const MarketerProperty(
    id: 'prop-2',
    title: 'فيلا مستقلة بحديقة',
    propertyType: 'فيلا',
    location: 'الرحاب، القاهرة الجديدة',
    areaLabel: '320 م²',
    priceLabel: '9,500,000 ج.م',
  ),
  const MarketerProperty(
    id: 'prop-3',
    title: 'دوبلكس حديث التشطيب',
    propertyType: 'دوبلكس',
    location: 'مدينتي، القاهرة',
    areaLabel: '200 م²',
    priceLabel: '5,200,000 ج.م',
  ),
];

/// Simple in-memory lookup — replace with a repository call once the
/// backend is wired up.
MarketerProperty? findMarketerPropertyById(String? id) {
  if (id == null) return null;
  for (final property in mockMarketerProperties) {
    if (property.id == id) return property;
  }
  return null;
}

void addMarketerProperty(MarketerProperty property) {
  mockMarketerProperties.add(property);
}

void updateMarketerProperty(MarketerProperty property) {
  final index = mockMarketerProperties.indexWhere((p) => p.id == property.id);
  if (index != -1) mockMarketerProperties[index] = property;
}

void deleteMarketerProperty(String id) {
  mockMarketerProperties.removeWhere((p) => p.id == id);
}
