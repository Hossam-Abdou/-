import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/subscription_models.dart';

class SubscriptionsRepository {
  SubscriptionsRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<List<PlanModel>> plans() async {
    final data = await apiClient.get(ApiEndpoints.plans);
    return [for (final p in data['data'] as List) PlanModel.fromJson(Map<String, dynamic>.from(p))];
  }

  /// null when the marketer has no subscription.
  Future<SubscriptionModel?> current() async {
    final data = await apiClient.get(ApiEndpoints.currentSubscription);
    final s = data['subscription'];
    return s is Map ? SubscriptionModel.fromJson(Map<String, dynamic>.from(s)) : null;
  }

  Future<SubscriptionModel> subscribe(String planId) async => SubscriptionModel.fromJson(
      Map<String, dynamic>.from(await apiClient.post(ApiEndpoints.subscribe, body: {'plan_id': planId})));
}
