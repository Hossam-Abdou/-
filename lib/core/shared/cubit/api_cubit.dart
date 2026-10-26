import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/api_client.dart';

enum ApiStatus { initial, loading, success, failure }

/// State shared by every feature that loads data from the backend.
/// [items] is a list (requests, listings...), [selected] is one opened item
/// (the details screen), [total] is the server-side count for paging.
class ApiState<T> {
  final ApiStatus status;
  final List<T> items;
  final T? selected;
  final int total;
  final ApiException? error; // set when status == failure

  const ApiState({
    this.status = ApiStatus.initial,
    this.items = const [],
    this.selected,
    this.total = 0,
    this.error,
  });

  bool get isLoading => status == ApiStatus.loading;

  ApiState<T> copyWith({
    ApiStatus? status,
    List<T>? items,
    T? Function()? selected, // wrapped so `null` can be set on purpose
    int? total,
    ApiException? Function()? error,
  }) {
    return ApiState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      selected: selected != null ? selected() : this.selected,
      total: total ?? this.total,
      error: error != null ? error() : this.error,
    );
  }
}

/// Base view model: runs a request and moves the state
/// loading -> success, or loading -> failure (the old data is kept).
abstract class ApiCubit<T> extends Cubit<ApiState<T>> {
  ApiCubit() : super(ApiState<T>());

  /// [action] returns the new state on success. Returns true if it worked.
  Future<bool> run(Future<ApiState<T>> Function() action) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      emit(await action());
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
