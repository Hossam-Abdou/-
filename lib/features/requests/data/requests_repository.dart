import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/request_model.dart';

class RequestsRepository {
  RequestsRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  /// Customer: own requests. Marketer: open requests from everyone.
  Future<({List<RequestModel> items, int total})> list({
    String? status,
    int? cityId,
    int? districtId,
    String? propertyType,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await apiClient.get(ApiEndpoints.requests, query: {
      if (status != null) 'status': status,
      if (cityId != null) 'city_id': '$cityId',
      if (districtId != null) 'district_id': '$districtId',
      if (propertyType != null) 'property_type': propertyType,
      'limit': '$limit',
      'offset': '$offset',
    });
    final items = [for (final r in data['data'] as List) RequestModel.fromJson(Map<String, dynamic>.from(r))];
    return (items: items, total: (data['count'] as num?)?.toInt() ?? items.length);
  }

  Future<RequestModel> details(String id) async =>
      RequestModel.fromJson(Map<String, dynamic>.from(await apiClient.get(ApiEndpoints.request(id))));

  Future<RequestModel> create(RequestInput input) async =>
      RequestModel.fromJson(Map<String, dynamic>.from(await apiClient.post(ApiEndpoints.requests, body: input.toJson())));

  Future<RequestModel> update(String id, RequestInput input) async => RequestModel.fromJson(
      Map<String, dynamic>.from(await apiClient.patch(ApiEndpoints.request(id), body: input.toJson())));

  Future<void> delete(String id) => apiClient.delete(ApiEndpoints.request(id));

  Future<RequestModel> close(String id) async =>
      RequestModel.fromJson(Map<String, dynamic>.from(await apiClient.post(ApiEndpoints.closeRequest(id))));
}
