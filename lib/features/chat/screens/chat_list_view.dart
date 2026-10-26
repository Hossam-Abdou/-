import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/shared/widgets/skeleton_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../../../core/shared/widgets/conversation_tile.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../../listings/widgets/listings_message.dart';
import '../cubit/chat_cubits.dart';
import '../data/chat_repository.dart';
import '../models/chat_models.dart';
import 'chat_room_screen.dart';

/// The "Messages" tab for both customer and marketer: real conversations
/// from `GET chat/conversations`. Content only, no Scaffold (the tab shell has it).
class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(ChatRepository())..load(),
      child: const _List(),
    );
  }
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    final myId = supabaseInstance.auth.currentUser?.id ?? '';

    return SafeArea(
      child: BlocBuilder<ChatCubit, ApiState<ConversationModel>>(
        builder: (context, state) {
          // A chat opened with "Contact" stays hidden until someone writes.
          final shown = [for (final c in state.items) if (c.lastMessage != null) c];
          final message = ListingsMessage.of(state.copyWith(items: shown), () => context.read<ChatCubit>().load(), skeleton: SkeletonStyle.row);
          return RefreshIndicator(
            onRefresh: () => context.read<ChatCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(LocaleKeys.navMessages.tr(), style: AppTextStyles.heading2, textAlign: TextAlign.start),
                ),
                if (message != null && shown.isEmpty && state.status == ApiStatus.success)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(LocaleKeys.noMessagesTitle.tr(), style: AppTextStyles.heading4, textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(LocaleKeys.noMessagesDesc.tr(), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                      ],
                    ),
                  )
                else if (message != null)
                  message
                else
                  for (final c in shown) ...[
                    ConversationTile(
                      name: c.other(myId)?.fullName ?? '',
                      subtitle: c.requestTitle,
                      lastMessage: c.lastMessage ?? '',
                      time: chatTime(context, c.lastMessageAt),
                      unread: false,
                      onTap: () async {
                        openChatRoom(context, c);
                      },
                    ),
                    const Divider(color: AppColors.border, height: 1),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}
