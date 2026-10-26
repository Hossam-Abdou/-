import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/listings_repository.dart';
import '../models/listing_model.dart';

/// Browse screen (customer): filters, paging and the opened listing.
class ListingsCubit extends Cubit<ApiState<ListingModel>> {
  ListingsCubit(this.listingsRepository) : super(const ApiState());
  final ListingsRepository listingsRepository;

  ListingFilter filter = const ListingFilter();

  /// Loads the first page with [newFilter] (or the current filter).
  Future<bool> load([ListingFilter? newFilter]) async {
    if (newFilter != null) filter = newFilter;
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final r = await listingsRepository.browse(filter);
      emit(state.copyWith(status: ApiStatus.success, items: r.items, total: r.total));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  /// Home screen: restrict the list to a city / district (null = everywhere).
  int? get cityId => filter.cityId;
  int? get districtId => filter.districtId;

  Future<bool> setLocation(int? cityId, int? districtId) =>
      load(ListingFilter(cityId: cityId, districtId: districtId));

  Future<bool> loadMore() async {
    if (state.isLoading || state.items.length >= state.total) return false;
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      final r = await listingsRepository.browse(filter, offset: state.items.length);
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
        final l = await listingsRepository.details(id);
        emit(state.copyWith(status: ApiStatus.success, selected: () => l));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}

/// Marketer's own listings (create / edit / delete / add photos).
class MyListingsCubit extends Cubit<ApiState<ListingModel>> {
  MyListingsCubit(this.listingsRepository) : super(const ApiState());
  final ListingsRepository listingsRepository;

  void clear() => emit(const ApiState());

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final items = await listingsRepository.mine();
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> create(ListingInput input) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final l = await listingsRepository.create(input);
        emit(state.copyWith(status: ApiStatus.success, items: [l, ...state.items], total: state.total + 1));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> update(String id, Map<String, dynamic> fields) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final l = await listingsRepository.update(id, fields);
        emit(state.copyWith(status: ApiStatus.success, items: [for (final e in state.items) e.id == id ? l : e]));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> delete(String id) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        await listingsRepository.delete(id);
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

  Future<bool> removeImages(String id, List<String> urls) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      await listingsRepository.removeImages(id, urls);
      emit(state.copyWith(status: ApiStatus.success));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> addImages(String id, List<String> urls) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        await listingsRepository.addImages(id, urls);
        emit(state.copyWith(status: ApiStatus.success));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}

/// Customer's saved listings.
class FavoritesCubit extends Cubit<ApiState<ListingModel>> {
  FavoritesCubit(this.listingsRepository) : super(const ApiState());
  final ListingsRepository listingsRepository;

  /// Called on logout so the next user doesn't see these.
  void clear() => emit(const ApiState());

  bool isFavorite(String id) => state.items.any((l) => l.id == id);

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final items = await listingsRepository.favorites();
        emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  /// Heart button: saves or removes [listing] and updates the list at once.
  Future<bool> toggle(ListingModel listing) async {
    final saved = isFavorite(listing.id);
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
      if (saved) {
        await listingsRepository.removeFavorite(listing.id);
      } else {
        await listingsRepository.addFavorite(listing.id);
      }
      final items = saved ? [for (final l in state.items) if (l.id != listing.id) l] : [listing, ...state.items];
      emit(state.copyWith(status: ApiStatus.success, items: items, total: items.length));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
