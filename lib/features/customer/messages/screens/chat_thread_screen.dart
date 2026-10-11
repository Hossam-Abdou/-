import 'package:flutter/material.dart';
import '../../../../core/shared/models/chat_message.dart';
import '../../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../../core/shared/widgets/chat_bubble.dart';
import '../../../../core/shared/widgets/chat_input_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/conversation.dart';

/// Full-screen thread with one marketer. Takes the conversation's id
/// through `settings.arguments` (see [AppRoutes.chatThread]) and
/// looks it up from the mock data.
///
/// New messages the client sends are appended to the in-memory
/// [Conversation.messages] list so the thread feels alive for the
/// rest of the session — swap for a real chat backend later.
class ChatThreadScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatThreadScreen({super.key, required this.conversation});

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  void _send(String text) {
    setState(() {
      widget.conversation.messages.add(ChatMessage(text: text, isMine: true, time: 'الآن'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.conversation.messages;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.conversation.marketerName, style: AppTextStyles.heading3),
        leading: const AppBackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) => ChatBubble(message: messages[index]),
            ),
          ),
          ChatInputBar(onSend: _send),
        ],
      ),
    );
  }
}
