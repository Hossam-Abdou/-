/// One message inside a conversation thread. Shared by both the
/// client and marketer messaging features — only the surrounding
/// [Conversation] model (who the other party is) differs per role.
class ChatMessage {
  final String text;
  final bool isMine;
  final String time;

  const ChatMessage({required this.text, required this.isMine, required this.time});
}
