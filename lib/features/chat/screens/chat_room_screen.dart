import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/shared/widgets/skeleton_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_text.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../../../core/shared/models/chat_message.dart';
import '../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../core/shared/widgets/chat_bubble.dart';
import '../../../core/shared/widgets/chat_input_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../../listings/widgets/listings_message.dart';
import '../cubit/chat_cubits.dart';
import '../data/chat_repository.dart';
import '../models/chat_models.dart';

/// Opens one real conversation (used by both customer and marketer).
void openChatRoom(BuildContext context, ConversationModel conversation, {String? title}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoomScreen(conversation: conversation, title: title)));
}

String chatTime(BuildContext context, DateTime? t) {
  if (t == null) return '';
  final local = t.toLocal();
  final now = DateTime.now();
  final lang = context.locale.languageCode;
  final sameDay = local.year == now.year && local.month == now.month && local.day == now.day;
  return sameDay ? DateFormat.jm(lang).format(local) : DateFormat.MMMd(lang).format(local);
}

class ChatRoomScreen extends StatelessWidget {
  final ConversationModel conversation;
  final String? title; // used when the conversation came without profiles
  const ChatRoomScreen({super.key, required this.conversation, this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit(ChatRepository(), conversation.id)..load(),
      child: _Room(conversation: conversation, title: title),
    );
  }
}

class _Room extends StatefulWidget {
  final ConversationModel conversation;
  final String? title;
  const _Room({required this.conversation, this.title});

  @override
  State<_Room> createState() => _RoomState();
}

class _RoomState extends State<_Room> {
  final _scroll = ScrollController();
  Timer? _poll;
  final myId = supabaseInstance.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    // No realtime yet: look for new messages every few seconds.
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => context.read<MessagesCubit>().refresh());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final other = widget.conversation.other(myId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(other?.fullName ?? widget.title ?? '', style: AppTextStyles.heading3),
            if (widget.conversation.requestTitle != null)
              Text(widget.conversation.requestTitle!, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        leading: const AppBackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessagesCubit, ApiState<MessageModel>>(
              listenWhen: (a, b) => a.items.length != b.items.length,
              listener: (context, state) => WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
              }),
              builder: (context, state) {
                if (state.items.isEmpty && state.status == ApiStatus.success) {
                  return Center(child: Text(LocaleKeys.chatEmpty.tr(), style: AppTextStyles.bodySmall));
                }
                final message = ListingsMessage.of(state, () => context.read<MessagesCubit>().load(), skeleton: SkeletonStyle.row);
                if (message != null && state.status != ApiStatus.success) {
                  return SingleChildScrollView(child: message);
                }
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, i) {
                    final m = state.items[i];
                    return ChatBubble(
                      message: ChatMessage(text: m.content, isMine: m.senderId == myId, time: chatTime(context, m.createdAt)),
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(
            onSend: (text) async {
              final cubit = context.read<MessagesCubit>();
              final messenger = ScaffoldMessenger.of(context);
              final ok = await cubit.send(text);
              if (!ok && cubit.state.error != null) {
                messenger.showSnackBar(SnackBar(content: Text(cubit.state.error!.text), backgroundColor: AppColors.error));
              }
            },
          ),
        ],
      ),
    );
  }
}
