import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/chat_repository.dart';
import '../models/chat_models.dart';

/// Inbox: the list of conversations.
class ChatCubit extends Cubit<ApiState<ConversationModel>> {
  ChatCubit(this.chatRepository) : super(const ApiState());
  final ChatRepository chatRepository;

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final items = await chatRepository.conversations();
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  /// "Contact" button: opens a chat with [otherUserId] and puts it first.
  Future<bool> start(String otherUserId, {String? relatedRequestId}) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final c = await chatRepository.start(otherUserId, relatedRequestId: relatedRequestId);
        final rest = [for (final e in state.items) if (e.id != c.id) e];
        emit(state.copyWith(status: ApiStatus.success, items: [c, ...rest], selected: () => c));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}

/// One open conversation: its messages (oldest first).
class MessagesCubit extends Cubit<ApiState<MessageModel>> {
  MessagesCubit(this.chatRepository, this.conversationId) : super(const ApiState());
  final ChatRepository chatRepository;
  final String conversationId;

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final items = await chatRepository.messages(conversationId);
        await chatRepository.markRead(conversationId);
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  /// Silent reload used by the screen's timer: no loading state, errors ignored.
  Future<void> refresh() async {
    try {
      final items = await chatRepository.messages(conversationId);
      if (items.length != state.items.length) {
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
        await chatRepository.markRead(conversationId);
      }
    } on ApiException {
      // keep what is on screen
    }
  }

  /// Older messages, added at the top.
  Future<bool> loadOlder() async {
    if (state.isLoading || state.items.isEmpty) return false;
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final first = state.items.first.createdAt;
      final older = await chatRepository.messages(conversationId, before: first?.toUtc().toIso8601String());
      emit(state.copyWith(status: ApiStatus.success, items: [...older, ...state.items], total: state.total + older.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> send(String content) async {
    final text = content.trim();
    if (text.isEmpty) return false;
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final m = await chatRepository.send(conversationId, text);
      emit(state.copyWith(status: ApiStatus.success, items: [...state.items, m], total: state.total + 1));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
