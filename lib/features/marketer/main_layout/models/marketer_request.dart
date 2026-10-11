enum MarketerRequestStatus { none, offerSent }

/// A single client request available to a marketer/agent, and the
/// backing model for the request details / search screens.
/// Demo copy only — will come from the backend later.
class MarketerRequest {
  final String id;
  final String customerName;
  final String propertyType;
  final String location;
  final String bedsLabel;
  final String bathsLabel;
  final String areaLabel;
  final String budgetRange;
  final String description;
  final MarketerRequestStatus status;

  /// Id of the existing conversation with this customer, if one has
  /// already started (see [features/marketer/messages]) — null means
  /// no chat has been opened with them yet.
  final String? conversationId;

  /// Id of the matching request in the *customer's* own request list
  /// (see `features/customer/home/models/property_request.dart`) —
  /// null when this demo request has no counterpart there. Lets a
  /// sent offer actually show up on the customer's side.
  final String? linkedCustomerRequestId;

  const MarketerRequest({
    required this.id,
    required this.customerName,
    required this.propertyType,
    required this.location,
    required this.bedsLabel,
    required this.bathsLabel,
    required this.areaLabel,
    required this.budgetRange,
    this.description = '',
    this.status = MarketerRequestStatus.none,
    this.conversationId,
    this.linkedCustomerRequestId,
  });
}

const List<MarketerRequest> mockMarketerRequests = [
  MarketerRequest(
    id: 'mreq-1',
    customerName: 'محمد عبد الله',
    propertyType: 'شقة',
    location: 'التجمع الخامس، القاهرة الجديدة',
    bedsLabel: '3 غرف',
    bathsLabel: '2 حمام',
    areaLabel: '150-180 م²',
    budgetRange: '3 - 5 مليون ج.م',
    description: 'عميل جاهز للشراء الفوري، يفضل تشطيب سوبر لوكس ودور مرتفع، ومتاح للمعاينة خلال هذا الأسبوع.',
    conversationId: 'mconv-1',
    linkedCustomerRequestId: 'req-1',
  ),
  MarketerRequest(
    id: 'mreq-2',
    customerName: 'ياسمين خالد',
    propertyType: 'فيلا',
    location: 'الرحاب، القاهرة الجديدة',
    bedsLabel: '4+ غرف',
    bathsLabel: '4 حمام',
    areaLabel: '250+ م²',
    budgetRange: '8 - 12 مليون ج.م',
    description: 'عميل يبحث عن فيلا مستقلة بحديقة، ميزانية مرنة لو العقار مطابق للمواصفات، تم إرسال عرض بالفعل.',
    status: MarketerRequestStatus.offerSent,
    conversationId: 'mconv-2',
  ),
  MarketerRequest(
    id: 'mreq-3',
    customerName: 'كريم عادل',
    propertyType: 'دوبلكس',
    location: 'مدينتي، القاهرة',
    bedsLabel: '3 غرف',
    bathsLabel: '3 حمام',
    areaLabel: '180-220 م²',
    budgetRange: '4.5 - 6 مليون ج.م',
    description: 'مطلوب دوبلكس بحالة جيدة في مدينتي، يفضل قرب من البوابة الرئيسية والخدمات.',
  ),
];

/// Simple in-memory lookup — replace with a repository call once the
/// backend is wired up.
MarketerRequest? findMarketerRequestById(String? id) {
  if (id == null) return null;
  for (final request in mockMarketerRequests) {
    if (request.id == id) return request;
  }
  return null;
}

/// Case-insensitive match across location/property type — used by
/// both the inline filters and the dedicated marketer search screen.
List<MarketerRequest> searchMarketerRequests(String query, {String? propertyType}) {
  final normalizedQuery = query.trim();
  return mockMarketerRequests.where((r) {
    final matchesType = propertyType == null || propertyType.isEmpty || r.propertyType == propertyType;
    final matchesQuery = normalizedQuery.isEmpty ||
        r.location.contains(normalizedQuery) ||
        r.propertyType.contains(normalizedQuery) ||
        r.budgetRange.contains(normalizedQuery) ||
        r.customerName.contains(normalizedQuery);
    return matchesType && matchesQuery;
  }).toList();
}
