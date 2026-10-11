import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/shared/widgets/conversation_tile.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/conversation.dart';

/// Content for the client "Messages" tab only — no Scaffold/bottom
/// nav here, [ClientShellScreen] owns those. Lists conversations with
/// marketers; tapping one opens [ChatThreadScreen].
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: mockCustomerConversations.isEmpty
          ? _EmptyMessages()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: mockCustomerConversations.length + 1,
              separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(LocaleKeys.navMessages.tr(), style: AppTextStyles.heading2, textAlign: TextAlign.start),
                  );
                }
                final conversation = mockCustomerConversations[index - 1];
                return ConversationTile(
                  name: conversation.marketerName,
                  subtitle: conversation.relatedRequestTitle,
                  lastMessage: conversation.lastMessage,
                  time: conversation.lastMessageTime,
                  unread: conversation.unread,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.chatThread, arguments: conversation.id),
                );
              },
            ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(LocaleKeys.noMessagesTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(LocaleKeys.noMessagesDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
