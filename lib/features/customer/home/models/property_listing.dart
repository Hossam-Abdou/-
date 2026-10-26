/// A property posted by a marketer, as the customer sees it on Home.
/// Matches the backend `property_listings` view (sale or rent), so this
/// demo list can be swapped for real data later.
///
/// NOTE: title/location/marketerName are demo copy (data), not UI labels,
/// so they are not run through easy_localization.
class PropertyListing {
  final String id;
  final String title;
  final String propertyType;
  final String location;
  final int area; // m²
  final int rooms;
  final int bathrooms;
  final bool isRent; // false = for sale
  final num price; // sale price, or monthly rent when [isRent]
  final String marketerName;
  final double marketerRating;
  final bool isNew;

  const PropertyListing({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.location,
    required this.area,
    required this.rooms,
    required this.bathrooms,
    required this.isRent,
    required this.price,
    required this.marketerName,
    this.marketerRating = 0,
    this.isNew = false,
  });
}

const List<PropertyListing> mockMarketerListings = [
  PropertyListing(
    id: 'l-1',
    title: 'شقة تشطيب سوبر لوكس',
    propertyType: 'شقة',
    location: 'التجمع الخامس، القاهرة الجديدة',
    area: 175,
    rooms: 3,
    bathrooms: 2,
    isRent: false,
    price: 3800000,
    marketerName: 'أحمد رضوان',
    marketerRating: 4.8,
    isNew: true,
  ),
  PropertyListing(
    id: 'l-2',
    title: 'فيلا مستقلة بحديقة',
    propertyType: 'فيلا',
    location: 'الرحاب، القاهرة الجديدة',
    area: 320,
    rooms: 5,
    bathrooms: 4,
    isRent: false,
    price: 9500000,
    marketerName: 'منى السيد',
    marketerRating: 4.6,
  ),
  PropertyListing(
    id: 'l-3',
    title: 'شقة مفروشة للإيجار',
    propertyType: 'شقة',
    location: 'مدينة نصر، القاهرة',
    area: 130,
    rooms: 2,
    bathrooms: 1,
    isRent: true,
    price: 14000,
    marketerName: 'خالد عبد الله',
    marketerRating: 4.9,
    isNew: true,
  ),
  PropertyListing(
    id: 'l-4',
    title: 'دوبلكس حديث التشطيب',
    propertyType: 'دوبلكس',
    location: 'مدينتي، القاهرة',
    area: 200,
    rooms: 4,
    bathrooms: 3,
    isRent: false,
    price: 5200000,
    marketerName: 'أحمد رضوان',
    marketerRating: 4.8,
  ),
  PropertyListing(
    id: 'l-5',
    title: 'شقة بإطلالة بحرية',
    propertyType: 'شقة',
    location: 'سموحة، الإسكندرية',
    area: 150,
    rooms: 3,
    bathrooms: 2,
    isRent: true,
    price: 18000,
    marketerName: 'سارة محمود',
    marketerRating: 4.7,
  ),
];
