import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/requests_repository.dart';
import '../models/request_model.dart';

/// Requests list + one opened request (`state.selected`).
class RequestsCubit extends Cubit<ApiState<RequestModel>> {
  RequestsCubit(this.requestsRepository) : super(const ApiState());
  final RequestsRepository requestsRepository;

  /// Called on logout so the next user doesn't see these.
  void clear() => emit(const ApiState());

  Future<bool> load({String? status, int? cityId, int? districtId, String? propertyType}) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await requestsRepository.list(
          status: status,
          cityId: cityId,
          districtId: districtId,
          propertyType: propertyType,
        );
        emit(state.copyWith(status: ApiStatus.success, items: r.items, total: r.total));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  /// Next page, appended to the current list.
  Future<bool> loadMore({String? status, int? cityId, int? districtId, String? propertyType}) async {
    if (state.isLoading || state.items.length >= state.total) return false;
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final r = await requestsRepository.list(
        status: status,
        cityId: cityId,
        districtId: districtId,
        propertyType: propertyType,
        offset: state.items.length,
      );
      emit(state.copyWith(status: ApiStatus.success, items: [...state.items, ...r.items], total: r.total));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> open(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await requestsRepository.details(id);
        emit(state.copyWith(status: ApiStatus.success, selected: () => r));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> create(RequestInput input) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await requestsRepository.create(input);
        emit(state.copyWith(status: ApiStatus.success, items: [r, ...state.items], total: state.total + 1));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> update(String id, RequestInput input) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await requestsRepository.update(id, input);
        emit(state.copyWith(
          status: ApiStatus.success,
          items: [for (final e in state.items) e.id == id ? r : e],
          selected: () => r,
        ));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> closeRequest(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final r = await requestsRepository.close(id);
        emit(state.copyWith(
          status: ApiStatus.success,
          items: [for (final e in state.items) e.id == id ? r : e],
          selected: () => r,
        ));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> delete(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        await requestsRepository.delete(id);
        emit(state.copyWith(
          status: ApiStatus.success,
          items: [for (final e in state.items) if (e.id != id) e],
          total: state.total - 1,
        ));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
