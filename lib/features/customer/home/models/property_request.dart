/// A single "recent request" card on the client home screen, and the
/// backing model for the request details / search screens.
///
/// NOTE: title/location/price are demo copy, not app chrome — they'll
/// come from the backend later, so they're not run through
/// easy_localization the way UI labels are.
enum PropertyRequestStatus { open, offersReceived, closed }

class PropertyRequest {
  final String id;
  final String title;
  final String location;
  final String area;
  final int rooms;
  final int bathrooms;
  final String priceRange;
  final String propertyType;
  final String finishing;
  final String description;
  final bool isNew;
  final PropertyRequestStatus status;
  final int offersCount;

  const PropertyRequest({
    required this.id,
    required this.title,
    required this.location,
    required this.area,
    required this.rooms,
    required this.bathrooms,
    required this.priceRange,
    required this.propertyType,
    this.finishing = '',
    this.description = '',
    this.isNew = false,
    this.status = PropertyRequestStatus.open,
    this.offersCount = 0,
  });

  PropertyRequest copyWith({
    String? title,
    String? location,
    String? area,
    int? rooms,
    int? bathrooms,
    String? priceRange,
    String? propertyType,
    String? finishing,
    String? description,
  }) {
    return PropertyRequest(
      id: id,
      title: title ?? this.title,
      location: location ?? this.location,
      area: area ?? this.area,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      priceRange: priceRange ?? this.priceRange,
      propertyType: propertyType ?? this.propertyType,
      finishing: finishing ?? this.finishing,
      description: description ?? this.description,
      isNew: isNew,
      status: status,
      offersCount: offersCount,
    );
  }
}

/// In-memory only — replace with a repository once the backend
/// exists. Mutable (not const) so add/edit from
/// [AddEditRequestScreen] actually stick for the rest of the session.
final List<PropertyRequest> mockRecentRequests = [
  const PropertyRequest(
    id: 'req-1',
    title: 'مطلوب شقة 3 غرف',
    location: 'التجمع الخامس، القاهرة الجديدة',
    area: '150م',
    rooms: 3,
    bathrooms: 2,
    priceRange: '3,000,000 - 3,500,000 ج.م',
    propertyType: 'شقة',
    finishing: 'سوبر لوكس',
    description:
        'أبحث عن شقة عائلية في التجمع الخامس، تشطيب سوبر لوكس، الدور الثالث أو أعلى، قريبة من الخدمات والمدارس، وبها موقف سيارة خاص.',
    isNew: true,
    status: PropertyRequestStatus.offersReceived,
    offersCount: 3,
  ),
  const PropertyRequest(
    id: 'req-2',
    title: 'ابحث عن فيلا للإيجار',
    location: 'الشيخ زايد، الجيزة',
    area: '300م',
    rooms: 4,
    bathrooms: 4,
    priceRange: '40,000 - 50,000 ج.م / شهر',
    propertyType: 'فيلا',
    finishing: 'تشطيب متكامل',
    description:
        'مطلوب فيلا مستقلة للإيجار السنوي في الشيخ زايد، حديقة خاصة، مسبح يُفضل، تشطيب متكامل وجاهزة للسكن الفوري.',
    status: PropertyRequestStatus.open,
  ),
  const PropertyRequest(
    id: 'req-3',
    title: 'شقة إداري أو مكتب للبيع',
    location: 'مدينة نصر، القاهرة',
    area: '90م',
    rooms: 2,
    bathrooms: 1,
    priceRange: '1,800,000 - 2,200,000 ج.م',
    propertyType: 'مكتب',
    finishing: 'نصف تشطيب',
    description: 'أبحث عن وحدة إدارية أو مكتب في موقع رئيسي بمدينة نصر، على شارع تجاري، ومناسبة كمقر عمل.',
    isNew: true,
    status: PropertyRequestStatus.closed,
    offersCount: 1,
  ),
];

/// Simple in-memory lookup — replace with a repository call once the
/// backend is wired up. Returns null if the id doesn't match any
/// mock request (defensive, since ids will be real/dynamic later).
PropertyRequest? findPropertyRequestById(String? id) {
  if (id == null) return null;
  for (final request in mockRecentRequests) {
    if (request.id == id) return request;
  }
  return null;
}

void addPropertyRequest(PropertyRequest request) {
  mockRecentRequests.add(request);
}

void updatePropertyRequest(PropertyRequest request) {
  final index = mockRecentRequests.indexWhere((r) => r.id == request.id);
  if (index != -1) mockRecentRequests[index] = request;
}

/// Case-insensitive match across title/location/property type — the
/// same fields shown on the card — used by both the home search bar
/// and the dedicated search screen.
List<PropertyRequest> searchPropertyRequests(String query, {String? category}) {
  final normalizedQuery = query.trim();
  return mockRecentRequests.where((r) {
    final matchesCategory = category == null || category.isEmpty || r.propertyType == category;
    final matchesQuery = normalizedQuery.isEmpty ||
        r.title.contains(normalizedQuery) ||
        r.location.contains(normalizedQuery) ||
        r.propertyType.contains(normalizedQuery);
    return matchesCategory && matchesQuery;
  }).toList();
}
