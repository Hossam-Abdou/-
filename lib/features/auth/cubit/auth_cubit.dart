import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../core/network/api_client.dart';
import '../data/auth_repository.dart';
import '../models/auth_user.dart';
import '../models/user_role.dart';

enum AuthError { invalidCredentials, emailTaken, phoneTaken, network, unknown }

enum AuthStatus { idle, loading, success, failure }

extension AuthErrorFrom on ApiException {
  AuthError get authError {
    if (isNetwork) return AuthError.network;
    if (status == 401) return AuthError.invalidCredentials;
    if (status == 409) return message.toLowerCase().contains('phone') ? AuthError.phoneTaken : AuthError.emailTaken;
    return AuthError.unknown;
  }
}

extension AuthErrorText on AuthError {
  String get text {
    switch (this) {
      case AuthError.invalidCredentials:
        return LocaleKeys.authErrInvalidCredentials.tr();
      case AuthError.emailTaken:
        return LocaleKeys.authErrEmailTaken.tr();
      case AuthError.phoneTaken:
        return LocaleKeys.authErrPhoneTaken.tr();
      case AuthError.network:
        return LocaleKeys.authErrNetwork.tr();
      case AuthError.unknown:
        return LocaleKeys.authErrGeneric.tr();
    }
  }
}

/// Everything the Login and Sign Up screens need to remember besides the
/// text typed into the fields (those stay in the screens' controllers).
class AuthState {
  final UserRole role; // the selected tab / card; after success it is the account's real role
  final AuthStatus status;
  final AuthError? error; // set when status == failure
  final bool remember; // login: "remember me"
  final bool acceptedTerms; // sign up
  final bool termsError; // sign up: show the red message under the checkbox
  final int cityId; // sign up
  final int? districtId; // sign up

  const AuthState({
    this.role = UserRole.client,
    this.status = AuthStatus.idle,
    this.error,
    this.remember = false,
    this.acceptedTerms = false,
    this.termsError = false,
    this.cityId = 1, // Cairo
    this.districtId,
  });

  AuthState copyWith({
    UserRole? role,
    AuthStatus? status,
    AuthError? Function()? error, // wrapped so `null` can be set on purpose
    bool? remember,
    bool? acceptedTerms,
    bool? termsError,
    int? cityId,
    int? Function()? districtId,
  }) {
    return AuthState(
      role: role ?? this.role,
      status: status ?? this.status,
      error: error != null ? error() : this.error,
      remember: remember ?? this.remember,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      termsError: termsError ?? this.termsError,
      cityId: cityId ?? this.cityId,
      districtId: districtId != null ? districtId() : this.districtId,
    );
  }
}

/// View model of Login and Sign Up (each screen creates its own).
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(const AuthState());
  final AuthRepository authRepository;

  void selectRole(UserRole role) => emit(state.copyWith(role: role));
  void toggleRemember() => emit(state.copyWith(remember: !state.remember));

  void setTerms(bool value) => emit(state.copyWith(acceptedTerms: value, termsError: false));
  void showTermsError() => emit(state.copyWith(termsError: !state.acceptedTerms));

  void selectCity(int cityId) {
    if (cityId == state.cityId) return;
    // districts belong to a city, so the old one is cleared
    emit(state.copyWith(cityId: cityId, districtId: () => null));
  }

  void selectDistrict(int? districtId) => emit(state.copyWith(districtId: () => districtId));

  Future<void> login({required String email, required String password}) async {
    if (state.status == AuthStatus.loading) return;
    emit(state.copyWith(status: AuthStatus.loading, error: () => null));
    try {
      final user = await authRepository.login(email: email, password: password, remember: state.remember);
      emit(state.copyWith(status: AuthStatus.success, role: user.role));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, error: () => e.authError));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone, // already normalized: "+201012345678"
    required String password,
  }) async {
    if (state.status == AuthStatus.loading) return;
    emit(state.copyWith(status: AuthStatus.loading, error: () => null));
    try {
      final user = await authRepository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: state.role,
        cityId: state.cityId,
        districtId: state.districtId,
      );
      emit(state.copyWith(status: AuthStatus.success, role: user.role));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, error: () => e.authError));
    }
  }
}
