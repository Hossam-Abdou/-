/// A property the customer has saved/favorited. Demo copy only —
/// will come from the backend later.
class SavedProperty {
  final String id;
  final String title;
  final String location;
  final String priceRange;
  final String area;
  final String propertyType;

  const SavedProperty({
    required this.id,
    required this.title,
    required this.location,
    required this.priceRange,
    required this.area,
    required this.propertyType,
  });
}

const List<SavedProperty> mockSavedProperties = [
  SavedProperty(
    id: 'saved-1',
    title: 'شقة تشطيب سوبر لوكس',
    location: 'التجمع الخامس، القاهرة الجديدة',
    priceRange: '3,800,000 ج.م',
    area: '175 م²',
    propertyType: 'شقة',
  ),
  SavedProperty(
    id: 'saved-2',
    title: 'فيلا مستقلة بحديقة',
    location: 'الرحاب، القاهرة الجديدة',
    priceRange: '9,500,000 ج.م',
    area: '320 م²',
    propertyType: 'فيلا',
  ),
];
