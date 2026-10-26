/// Where a single offer stands with the customer — separate from the
/// request's own status ([PropertyRequestStatus], which reflects
/// *all* offers together). New offers start [pending]; the customer
/// accepting/declining one (once that action exists) would move it to
/// [accepted]/[declined].
enum OfferStatus { pending, accepted, declined }

/// A short preview of an offer a marketer sent on one of the
/// customer's main_layout — shown inline on the request-details screen.
/// Demo copy only — will come from the backend later.
class OfferPreview {
  final String id;
  final String? marketerId; // backend profile id, used to start a chat
  final String? requestId; // the request it answers, so its chat is about that request
  final String marketerName;
  final double rating;
  final int reviewsCount;
  final String timeAgo;
  final String message;
  final OfferStatus status;

  /// The offered property's title and photos, so the customer can
  /// actually see what's being offered — entries can be local file
  /// paths (from the marketer's device, no backend/upload yet) or
  /// `http(s)` URLs (demo photos) — [PropertyImageStrip] and
  /// [FullScreenImageGallery] render either. Empty if the marketer
  /// hadn't added any photos to that property.
  final String? propertyTitle;
  final List<String> propertyImagePaths;

  const OfferPreview({
    required this.id,
    this.marketerId,
    this.requestId,
    required this.marketerName,
    required this.rating,
    required this.reviewsCount,
    required this.timeAgo,
    required this.message,
    this.status = OfferStatus.pending,
    this.propertyTitle,
    this.propertyImagePaths = const [],
  });

  OfferPreview copyWith({OfferStatus? status}) {
    return OfferPreview(
      id: id,
      marketerId: marketerId,
      requestId: requestId,
      marketerName: marketerName,
      rating: rating,
      reviewsCount: reviewsCount,
      timeAgo: timeAgo,
      message: message,
      status: status ?? this.status,
      propertyTitle: propertyTitle,
      propertyImagePaths: propertyImagePaths,
    );
  }
}

final Map<String, List<OfferPreview>> _mockOfferPreviewsByRequestId = {
  'req-1': [
    OfferPreview(
      id: 'offer-1',
      marketerName: 'أحمد مصطفى',
      rating: 4.8,
      reviewsCount: 120,
      timeAgo: 'منذ ساعتين',
      message:
          'أهلاً بك، لدي شقة مطابقة تماماً للمواصفات المطلوبة في حي النرجس، دور ثالث، تشطيب سوبر لوكس بالكامل، وقريبة جداً من الخدمات والمدارس. الشقة جاهزة للمعاينة في أي وقت يناسبك.',
      propertyTitle: 'شقة تشطيب سوبر لوكس',
      status: OfferStatus.accepted,
      propertyImagePaths: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800',
      ],
    ),
    OfferPreview(
      id: 'offer-2',
      marketerName: 'سارة محمود',
      rating: 4.9,
      reviewsCount: 85,
      timeAgo: 'منذ 5 ساعات',
      message: 'يتوفر لدينا عرض ممتاز بتشطيب سوبر لوكس وبسعر مناسب جداً...',
      propertyTitle: 'شقة عائلية بحي راقٍ',
      status: OfferStatus.pending,
      propertyImagePaths: [
        'https://images.unsplash.com/photo-1560184897-ae75f418493e?w=800',
        'https://images.unsplash.com/photo-1560185893-a55cbc8c57e8?w=800',
      ],
    ),
  ],
  'req-3': [
    OfferPreview(
      id: 'offer-3',
      marketerName: 'كريم عادل',
      rating: 4.6,
      reviewsCount: 40,
      timeAgo: 'منذ يوم',
      message: 'عندي مكتب إداري في نفس الموقع المطلوب، جاهز للمعاينة...',
      propertyTitle: 'مكتب إداري مجهز',
      status: OfferStatus.declined,
      propertyImagePaths: ['https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=800'],
    ),
  ],
};

/// Returns the (up to 2) preview offers for a request — replace with
/// a repository call once the backend is wired up.
List<OfferPreview> mockOfferPreviewsForRequest(String requestId) {
  return _mockOfferPreviewsByRequestId[requestId] ?? const [];
}

/// Looks up a single offer by id across every request — used by
/// [AppRoutes.offerDetails] to open [OfferDetailsScreen]. Replace
/// with a repository call once the backend exists.
OfferPreview? findOfferPreviewById(String? id) {
  if (id == null) return null;
  for (final offers in _mockOfferPreviewsByRequestId.values) {
    for (final offer in offers) {
      if (offer.id == id) return offer;
    }
  }
  return null;
}

/// Replaces the offers shown for [requestId] with the ones loaded from the
/// server, so the offer details screen can find them by id.
void setOfferPreviews(String requestId, List<OfferPreview> offers) {
  _mockOfferPreviewsByRequestId[requestId] = List.of(offers);
}

/// Appends a newly-sent offer to a request's preview list — called
/// once [SendOfferScreen] "sends" an offer whose request has a
/// [MarketerRequest.linkedCustomerRequestId], so it actually shows up
/// on the customer's side for the rest of the session.
void addOfferPreview(String requestId, OfferPreview offer) {
  _mockOfferPreviewsByRequestId.putIfAbsent(requestId, () => []).insert(0, offer);
}

/// Accepts or declines one offer in place — called from
/// [OfferDetailsScreen]'s accept/decline actions. Replace with a
/// repository call once the backend exists.
void updateOfferStatus(String offerId, OfferStatus newStatus) {
  for (final offers in _mockOfferPreviewsByRequestId.values) {
    final index = offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      offers[index] = offers[index].copyWith(status: newStatus);
      return;
    }
  }
}
