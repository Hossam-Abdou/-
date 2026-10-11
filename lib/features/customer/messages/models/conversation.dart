import '../../../../core/shared/models/chat_message.dart';

/// A conversation between the client and one marketer, shown on the
/// client's Messages tab. Demo copy only — will come from the
/// backend once real-time chat is wired up.
class Conversation {
  final String id;
  final String marketerName;
  final String? relatedRequestTitle;
  final bool unread;
  final List<ChatMessage> messages;

  const Conversation({
    required this.id,
    required this.marketerName,
    required this.messages,
    this.relatedRequestTitle,
    this.unread = false,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';
  String get lastMessageTime => messages.isNotEmpty ? messages.last.time : '';
}

final List<Conversation> mockCustomerConversations = [
  Conversation(
    id: 'conv-1',
    marketerName: 'أحمد سمير',
    relatedRequestTitle: 'مطلوب شقة 3 غرف',
    unread: true,
    messages: [
      const ChatMessage(text: 'أهلاً، شفت طلبك وعندي شقة تناسب مواصفاتك تمامًا.', isMine: false, time: '10:02 ص'),
      const ChatMessage(text: 'تمام، ممكن تبعتلي تفاصيل أكتر؟', isMine: true, time: '10:05 ص'),
      const ChatMessage(text: 'بعتلك عرض كامل بالسعر والمساحة، راجعه وقولي رأيك.', isMine: false, time: '10:08 ص'),
    ],
  ),
  Conversation(
    id: 'conv-2',
    marketerName: 'سارة محمود',
    relatedRequestTitle: 'ابحث عن فيلا للإيجار',
    messages: [
      const ChatMessage(text: 'هل الفيلا لسه متاحة للإيجار؟', isMine: true, time: 'أمس'),
      const ChatMessage(text: 'أيوه متاحة، تحب نحدد ميعاد معاينة؟', isMine: false, time: 'أمس'),
    ],
  ),
];

Conversation? findCustomerConversationById(String? id) {
  if (id == null) return null;
  for (final c in mockCustomerConversations) {
    if (c.id == id) return c;
  }
  return null;
}

/// Returns the existing conversation with [marketerName] if there is
/// one, otherwise starts a new empty one and adds it to the list —
/// used by "Send Message" on an offer's details so it always has
/// somewhere to open, whether or not the two have talked before.
Conversation findOrCreateConversationWithMarketer(String marketerName, {String? relatedRequestTitle}) {
  for (final c in mockCustomerConversations) {
    if (c.marketerName == marketerName) return c;
  }
  final conversation = Conversation(
    id: 'conv-${DateTime.now().millisecondsSinceEpoch}',
    marketerName: marketerName,
    relatedRequestTitle: relatedRequestTitle,
    messages: [],
  );
  mockCustomerConversations.add(conversation);
  return conversation;
}
