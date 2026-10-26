import '../../../core/data/locations.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

/// Cities / districts from the server. The app already ships the same list as
/// constants (`Locations`), so use this only if you want it to be dynamic.
class LocationsRepository {
  LocationsRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<List<City>> cities() async {
    final data = await apiClient.get(ApiEndpoints.cities);
    return [for (final c in data['data'] as List) City.fromJson(Map<String, dynamic>.from(c))];
  }

  Future<List<District>> districts({int? cityId}) async {
    final data = await apiClient.get(ApiEndpoints.districts, query: {if (cityId != null) 'city_id': '$cityId'});
    return [for (final d in data['data'] as List) District.fromJson(Map<String, dynamic>.from(d))];
  }
}
