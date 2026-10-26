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

  /// false = hidden from other users (only the marketer sees it).
  final bool isPublished;

  const MarketerProperty({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.location,
    required this.areaLabel,
    required this.priceLabel,
    this.isPublished = true,
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
