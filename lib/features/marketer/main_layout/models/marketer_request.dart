enum MarketerRequestStatus { none, offerSent }

/// A single client request available to a marketer/agent, and the
/// backing model for the request details / search screens.
/// Demo copy only — will come from the backend later.
class MarketerRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String propertyType;
  final String location;
  final String bedsLabel;
  final String bathsLabel;
  final String areaLabel;
  final String budgetRange;
  final String description;
  final MarketerRequestStatus status;
  final DateTime? createdAt;

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
    this.customerId = '',
    required this.customerName,
    required this.propertyType,
    required this.location,
    required this.bedsLabel,
    required this.bathsLabel,
    required this.areaLabel,
    required this.budgetRange,
    this.description = '',
    this.status = MarketerRequestStatus.none,
    this.createdAt,
    this.conversationId,
    this.linkedCustomerRequestId,
  });
}

/// Cache of the requests the marketer screens show. It is refilled from
/// the backend by `syncMarketerRequests` (see marketer_request_mapper.dart),
/// so the existing cards/search/details keep reading from one list.
final List<MarketerRequest> mockMarketerRequests = [];

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
