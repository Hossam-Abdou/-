import '../../../../core/shared/models/chat_message.dart';

/// A conversation between the marketer and one client, shown on the
/// marketer's Messages tab. Demo copy only — will come from the
/// backend once real-time chat is wired up.
class Conversation {
  final String id;
  final String customerName;
  final String? relatedRequestTitle;
  final bool unread;
  final List<ChatMessage> messages;

  const Conversation({
    required this.id,
    required this.customerName,
    required this.messages,
    this.relatedRequestTitle,
    this.unread = false,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';
  String get lastMessageTime => messages.isNotEmpty ? messages.last.time : '';
}

final List<Conversation> mockMarketerConversations = [
  Conversation(
    id: 'mconv-1',
    customerName: 'محمد عبد الله',
    relatedRequestTitle: 'التجمع الخامس، القاهرة الجديدة',
    unread: true,
    messages: [
      const ChatMessage(text: 'أرسلت لك عرض على الشقة، هل يمكنك المراجعة؟', isMine: true, time: '9:15 ص'),
      const ChatMessage(text: 'شكرًا، هراجعه وأرد عليك بعد شوية.', isMine: false, time: '9:20 ص'),
      const ChatMessage(text: 'السعر مناسب، بس ممكن نعرف تفاصيل التشطيب أكتر؟', isMine: false, time: '9:31 ص'),
    ],
  ),
  Conversation(
    id: 'mconv-2',
    customerName: 'ياسمين خالد',
    relatedRequestTitle: 'الرحاب، القاهرة الجديدة',
    messages: [
      const ChatMessage(text: 'هل الفيلا لسه متاحة؟', isMine: false, time: 'أمس'),
      const ChatMessage(text: 'أيوه متاحة، وجاهز أرسل لك عرض التفاصيل.', isMine: true, time: 'أمس'),
    ],
  ),
];

Conversation? findMarketerConversationById(String? id) {
  if (id == null) return null;
  for (final c in mockMarketerConversations) {
    if (c.id == id) return c;
  }
  return null;
}
