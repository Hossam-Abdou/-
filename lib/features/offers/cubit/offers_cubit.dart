import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/offers_repository.dart';
import '../models/offer_model.dart';

class OffersCubit extends Cubit<ApiState<OfferModel>> {
  OffersCubit(this.offersRepository) : super(const ApiState());
  final OffersRepository offersRepository;

  /// The conversation opened by the last [accept] (the screen navigates to it).
  String? lastConversationId;

  /// Called on logout so the next user doesn't see these.
  void clear() => emit(const ApiState());

  Future<bool> load({String? requestId, String? status}) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final items = await offersRepository.list(requestId: requestId, status: status);
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> send({required String requestId, String? propertyId, String? message, List<String> images = const []}) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final o = await offersRepository.create(
        requestId: requestId,
        propertyId: propertyId,
        message: message,
        images: images,
      );
      emit(state.copyWith(status: ApiStatus.success, items: [o, ...state.items], total: state.total + 1));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> accept(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await offersRepository.accept(id);
        lastConversationId = r.conversationId;
        emit(state.copyWith(
          status: ApiStatus.success,
          items: [for (final o in state.items) o.id == id ? r.offer : o],
        ));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> decline(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final offer = await offersRepository.decline(id);
        emit(state.copyWith(
          status: ApiStatus.success,
          items: [for (final o in state.items) o.id == id ? offer : o],
        ));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
