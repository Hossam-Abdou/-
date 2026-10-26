import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/shared/cubit/api_state.dart';
import '../data/profile_repository.dart';
import '../models/profile_model.dart';

/// The signed-in user's profile, kept in `state.selected`.
class ProfileCubit extends Cubit<ApiState<ProfileModel>> {
  ProfileCubit(this.profileRepository) : super(const ApiState());
  final ProfileRepository profileRepository;

  void clear() => emit(const ApiState());

  Future<bool> load() async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final me = await profileRepository.me();
        emit(state.copyWith(status: ApiStatus.success, selected: () => me));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }

  Future<bool> update({String? fullName, String? phone, String? avatarUrl, String? bio}) async {
    emit(state.copyWith(status: ApiStatus.loading, error: () => null));
    try {
        final me = await profileRepository.update(fullName: fullName, phone: phone, avatarUrl: avatarUrl, bio: bio);
        emit(state.copyWith(status: ApiStatus.success, selected: () => me));
      return true;
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, error: () => e));
      return false;
    }
  }
}
