import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/listing_model.dart';

class ListingsRepository {
  ListingsRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<({List<ListingModel> items, int total})> browse(ListingFilter filter, {int limit = 20, int offset = 0}) async {
    final data = await apiClient.get(ApiEndpoints.listings, query: {
      ...filter.toQuery(),
      'limit': '$limit',
      'offset': '$offset',
    });
    final items = [for (final l in data['data'] as List) ListingModel.fromJson(Map<String, dynamic>.from(l))];
    return (items: items, total: (data['count'] as num?)?.toInt() ?? items.length);
  }

  /// Allowed values for the pickers (listing_types, categories, furnishing, ...).
  Future<Map<String, List<String>>> meta() async {
    final data = await apiClient.get(ApiEndpoints.listingsMeta) as Map;
    return {
      for (final e in data.entries)
        if (e.value is List) '${e.key}': [for (final v in e.value as List) '$v'],
    };
  }

  Future<List<ListingModel>> mine() async {
    final data = await apiClient.get(ApiEndpoints.myListings);
    return [for (final l in data['data'] as List) ListingModel.fromJson(Map<String, dynamic>.from(l))];
  }

  Future<List<ListingModel>> favorites() async {
    final data = await apiClient.get(ApiEndpoints.favorites);
    // each row is `{created_at, property: {...}}`: the listing is inside `property`
    return [
      for (final row in data['data'] as List)
        if (row is Map && row['property'] is Map) ListingModel.fromJson(Map<String, dynamic>.from(row['property'])),
    ];
  }

  Future<ListingModel> details(String id) async =>
      ListingModel.fromJson(Map<String, dynamic>.from(await apiClient.get(ApiEndpoints.listing(id))));

  Future<ListingModel> create(ListingInput input) async =>
      ListingModel.fromJson(Map<String, dynamic>.from(await apiClient.post(ApiEndpoints.listings, body: input.toJson())));

  /// [fields] may also contain `status` and `is_published`.
  Future<ListingModel> update(String id, Map<String, dynamic> fields) async =>
      ListingModel.fromJson(Map<String, dynamic>.from(await apiClient.patch(ApiEndpoints.listing(id), body: fields)));

  Future<void> delete(String id) => apiClient.delete(ApiEndpoints.listing(id));

  Future<void> addImages(String id, List<String> urls) =>
      apiClient.post(ApiEndpoints.listingImages(id), body: {'images': urls});

  Future<void> removeImages(String id, List<String> urls) =>
      apiClient.post(ApiEndpoints.listingRemoveImages(id), body: {'images': urls});

  Future<void> addFavorite(String id) => apiClient.post(ApiEndpoints.listingFavorite(id));

  Future<void> removeFavorite(String id) => apiClient.delete(ApiEndpoints.listingFavorite(id));
}
