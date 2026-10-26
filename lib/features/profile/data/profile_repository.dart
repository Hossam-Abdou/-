import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  ProfileRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<ProfileModel> me() async => ProfileModel.fromJson(Map<String, dynamic>.from(await apiClient.get(ApiEndpoints.me)));

  Future<ProfileModel> update({String? fullName, String? phone, String? avatarUrl, String? bio}) async {
    final data = await apiClient.patch(ApiEndpoints.me, body: {
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (bio != null) 'bio': bio,
    });
    return ProfileModel.fromJson(Map<String, dynamic>.from(data));
  }
}
