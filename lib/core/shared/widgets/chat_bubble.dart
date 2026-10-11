import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../models/chat_message.dart';

/// A single message bubble — outgoing ("mine") messages align right
/// with a brand-colored background, incoming ones align left on a
/// plain surface. Used by both the client and marketer chat threads.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMine ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(message.isMine ? 14 : 2),
            bottomRight: Radius.circular(message.isMine ? 2 : 14),
          ),
          border: message.isMine ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyRegular.copyWith(color: message.isMine ? AppColors.textOnPrimary : AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: AppTextStyles.caption.copyWith(color: message.isMine ? Colors.white70 : AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
