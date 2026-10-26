import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/offer_model.dart';

class OffersRepository {
  OffersRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<List<OfferModel>> list({String? requestId, String? status}) async {
    final data = await apiClient.get(ApiEndpoints.offers, query: {
      if (requestId != null) 'request_id': requestId,
      if (status != null) 'status': status,
    });
    return [for (final o in data['data'] as List) OfferModel.fromJson(Map<String, dynamic>.from(o))];
  }

  /// Marketer sends an offer on a request.
  Future<OfferModel> create({
    required String requestId,
    String? propertyId,
    String? message,
    List<String> images = const [],
  }) async {
    final data = await apiClient.post(ApiEndpoints.offers, body: {
      'request_id': requestId,
      if (propertyId != null) 'property_id': propertyId,
      if (message != null) 'message': message,
      if (images.isNotEmpty) 'images': images,
    });
    return OfferModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// Customer accepts: returns the offer and the chat that was opened.
  Future<({OfferModel offer, String? conversationId})> accept(String id) async {
    final data = await apiClient.post(ApiEndpoints.acceptOffer(id));
    return (
      offer: OfferModel.fromJson(Map<String, dynamic>.from(data['offer'])),
      conversationId: data['conversation_id'] == null ? null : '${data['conversation_id']}',
    );
  }

  Future<OfferModel> decline(String id) async {
    final data = await apiClient.post(ApiEndpoints.declineOffer(id));
    return OfferModel.fromJson(Map<String, dynamic>.from(data['offer']));
  }
}
