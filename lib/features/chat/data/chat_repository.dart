import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/chat_models.dart';

class ChatRepository {
  ChatRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<List<ConversationModel>> conversations() async {
    final data = await apiClient.get(ApiEndpoints.conversations);
    return [for (final c in data['data'] as List) ConversationModel.fromJson(Map<String, dynamic>.from(c))];
  }

  /// Opens (or returns the existing) conversation with [otherUserId].
  Future<ConversationModel> start(String otherUserId, {String? relatedRequestId}) async {
    final data = await apiClient.post(ApiEndpoints.conversations, body: {
      'other_user_id': otherUserId,
      if (relatedRequestId != null) 'related_request_id': relatedRequestId,
    });
    return ConversationModel.fromJson(Map<String, dynamic>.from(data));
  }

  /// Oldest first. Pass [before] (an ISO date) to load older messages.
  Future<List<MessageModel>> messages(String conversationId, {int limit = 50, String? before}) async {
    final data = await apiClient.get(ApiEndpoints.messages(conversationId), query: {
      'limit': '$limit',
      if (before != null) 'before': before,
    });
    return [for (final m in data['data'] as List) MessageModel.fromJson(Map<String, dynamic>.from(m))];
  }

  Future<MessageModel> send(String conversationId, String content) async {
    final data = await apiClient.post(ApiEndpoints.messages(conversationId), body: {'content': content});
    return MessageModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> markRead(String conversationId) => apiClient.post(ApiEndpoints.markRead(conversationId));
}
