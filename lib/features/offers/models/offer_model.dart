import '../../../core/utils/json_utils.dart';
import '../../profile/models/profile_model.dart';
import '../../requests/models/request_model.dart';

class OfferModel {
  final String id;
  final String requestId;
  final String marketerId;
  final String? propertyId;
  final String? propertyTitle;
  final String? message;
  final String status; // pending | accepted | declined
  final DateTime? createdAt;
  final ProfileModel? marketer;
  final List<String> images;
  final RequestModel? request; // embedded by the list endpoint

  const OfferModel({
    required this.id,
    required this.requestId,
    required this.marketerId,
    this.propertyId,
    this.propertyTitle,
    this.message,
    this.status = 'pending',
    this.createdAt,
    this.marketer,
    this.images = const [],
    this.request,
  });

  bool get isPending => status == 'pending';

  factory OfferModel.fromJson(Map<String, dynamic> j) => OfferModel(
        id: '${j['id']}',
        requestId: '${j['request_id']}',
        marketerId: '${j['marketer_id']}',
        propertyId: j['property_id'] == null ? null : '${j['property_id']}',
        propertyTitle: j['property_title'] as String?,
        message: j['message'] as String?,
        status: '${j['status'] ?? 'pending'}',
        createdAt: toDate(j['created_at']),
        marketer: j['marketer'] is Map ? ProfileModel.fromJson(Map<String, dynamic>.from(j['marketer'])) : null,
        request: j['request'] is Map ? RequestModel.fromJson(Map<String, dynamic>.from(j['request'])) : null,
        images: j['offer_images'] is List
            ? [for (final i in j['offer_images']) '${(i as Map)['image_url'] ?? ''}']
            : const [],
      );
}
