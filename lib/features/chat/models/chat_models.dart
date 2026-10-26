import '../../../core/utils/json_utils.dart';
import '../../profile/models/profile_model.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime? createdAt;
  final DateTime? readAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.createdAt,
    this.readAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
        id: '${j['id']}',
        conversationId: '${j['conversation_id']}',
        senderId: '${j['sender_id']}',
        content: '${j['content'] ?? ''}',
        createdAt: toDate(j['created_at']),
        readAt: toDate(j['read_at']),
      );
}

class ConversationModel {
  final String id;
  final ProfileModel? customer;
  final ProfileModel? marketer;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastSenderId;

  /// The request this chat is about (null for a general chat).
  final String? requestTitle;

  const ConversationModel({
    required this.id,
    this.customer,
    this.marketer,
    this.lastMessage,
    this.lastMessageAt,
    this.lastSenderId,
    this.requestTitle,
  });

  /// The person on the other side of the chat.
  ProfileModel? other(String myId) => customer?.id == myId ? marketer : customer;

  factory ConversationModel.fromJson(Map<String, dynamic> j) {
    final last = j['last_message'] as Map?;
    ProfileModel? p(Object? v) => v is Map ? ProfileModel.fromJson(Map<String, dynamic>.from(v)) : null;
    return ConversationModel(
      id: '${j['id']}',
      customer: p(j['customer']),
      marketer: p(j['marketer']),
      lastMessage: last?['content'] as String?,
      lastMessageAt: toDate(last?['created_at']),
      lastSenderId: last?['sender_id'] as String?,
      requestTitle: (j['request'] is Map ? (j['request'] as Map)['title'] : null) as String?,
    );
  }
}
