import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthApiException;

import '../../../config/router/app_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/auth_user.dart';
import '../models/user_role.dart';

/// Talks to the `auth` Edge Function. After a successful login / sign up the
/// session is handed to the Supabase client, which stores it and sends the
/// token with every later request. Errors surface as [ApiException].
class AuthRepository {
  static const _rememberKey = 'remember_me';
  static const _secure = FlutterSecureStorage();
  static const _emailKey = 'cred_email';
  static const _passwordKey = 'cred_password';

  /// Credentials are kept in the device's secure storage (Keychain /
  /// Keystore), never in SharedPreferences, so the app can sign in again
  /// silently when the session cannot be refreshed.
  static Future<void> _saveCredentials(String email, String password) async {
    await _secure.write(key: _emailKey, value: email);
    await _secure.write(key: _passwordKey, value: password);
  }

  static Future<void> _clearCredentials() async {
    await _secure.delete(key: _emailKey);
    await _secure.delete(key: _passwordKey);
  }

  /// Signs in again with the saved credentials. False if there are none, they
  /// are no longer valid (then they are erased) or the server is unreachable.
  static Future<bool> silentLogin() async {
    final email = await _secure.read(key: _emailKey);
    final password = await _secure.read(key: _passwordKey);
    if (email == null || password == null) return false;
    try {
      final data = await ApiClient().post(ApiEndpoints.login, body: {'email': email, 'password': password});
      final session = data['session'];
      if (session is Map && session['refresh_token'] != null) {
        await supabaseInstance.auth.setSession('${session['refresh_token']}');
        return true;
      }
      return false;
    } on ApiException catch (e) {
      if (e.status == 400 || e.status == 401) await _clearCredentials();
      return false;
    }
  }

  AuthRepository({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();
  final ApiClient apiClient;

  Future<AuthUser> login({required String email, required String password, bool remember = false}) async {
    final data = await apiClient.post(ApiEndpoints.login, body: {'email': email, 'password': password});
    final session = data['session'];
    if (session is Map && session['refresh_token'] != null) {
      await supabaseInstance.auth.setSession('${session['refresh_token']}');
    }
    await (await SharedPreferences.getInstance()).setBool(_rememberKey, remember);
    if (remember) {
      await _saveCredentials(email, password);
    } else {
      await _clearCredentials();
    }
    final user = data['user'] as Map;
    final profile = (data['profile'] as Map?) ?? const {};
    return AuthUser(
      id: '${user['id']}',
      email: user['email'] as String?,
      fullName: '${profile['full_name'] ?? ''}',
      phone: profile['phone'] as String?,
      role: AuthUser.roleFrom(profile['role']),
    );
  }

  Future<AuthUser> register({
    required String fullName,
    required String email,
    required String phone, // "+201012345678"
    required String password,
    required UserRole role,
    int? cityId,
    int? districtId,
  }) async {
    final data = await apiClient.post(ApiEndpoints.signup, body: {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role == UserRole.marketer ? 'marketer' : 'customer',
      if (cityId != null) 'city_id': cityId,
      if (districtId != null) 'district_id': districtId,
    });
    final session = data['session'];
    if (session is Map && session['refresh_token'] != null) {
      await supabaseInstance.auth.setSession('${session['refresh_token']}');
    }
    await (await SharedPreferences.getInstance()).setBool(_rememberKey, true);
    await _saveCredentials(email, password);
    final user = data['user'] as Map;
    return AuthUser(
      id: '${user['id']}',
      email: user['email'] as String?,
      fullName: '${user['full_name'] ?? fullName}',
      phone: user['phone'] as String?,
      role: AuthUser.roleFrom(user['role']),
    );
  }

  Future<void> logout() async {
    await (await SharedPreferences.getInstance()).remove(_rememberKey);
    await _clearCredentials();
    await supabaseInstance.auth.signOut();
  }

  /// First screen of the app. The Supabase session is stored on the device;
  /// it is only reused when the user ticked "remember me" (or just signed up).
  static Future<String> startRoute() async {
    final remember = (await SharedPreferences.getInstance()).getBool(_rememberKey) ?? false;
    // Supabase may already have dropped the session at startup (refresh failed):
    // with "remember me" the saved credentials bring it back.
    if (supabaseInstance.auth.currentUser == null && remember) await silentLogin();
    final user = supabaseInstance.auth.currentUser;
    if (user == null) return AppRoutes.login;
    if (!remember) {
      await _clearCredentials();
      await supabaseInstance.auth.signOut();
      return AppRoutes.login;
    }
    // The saved access token may have expired while the app was closed:
    // renew it now. Only a refresh the server really rejects ends the
    // session; being offline keeps the user signed in.
    final session = supabaseInstance.auth.currentSession;
    if (session != null && session.isExpired) {
      try {
        await supabaseInstance.auth.refreshSession();
      } on AuthApiException {
        // The refresh token was rejected: sign in again with the saved credentials.
        if (!await silentLogin()) {
          await supabaseInstance.auth.signOut();
          return AppRoutes.login;
        }
      } catch (_) {
        // network problem: keep the saved session
      }
    }
    final role = user.appMetadata['user_role'] ?? user.userMetadata?['role'];
    return role == 'marketer' ? AppRoutes.marketerRequests : AppRoutes.home;
  }

  Future<void> resetPassword(String email) => apiClient.post(ApiEndpoints.resetPassword, body: {'email': email});
}
