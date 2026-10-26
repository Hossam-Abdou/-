import 'package:supabase_flutter/supabase_flutter.dart';

/// The one Supabase client of the app (available after `Supabase.initialize`).
/// It keeps the signed-in session and adds the user's token to every call.
SupabaseClient get supabaseInstance => Supabase.instance.client;

/// An error answered by the backend: `{"error": {"message": ...}}`.
/// [status] is the HTTP status (401, 403, 404, 409...) or null when the
/// server could not be reached at all.
class ApiException implements Exception {
  final int? status;
  final String message;
  const ApiException(this.status, this.message);

  bool get isNetwork => status == null;

  @override
  String toString() => 'ApiException($status, $message)';
}

/// Calls the Edge Functions listed in `ApiEndpoints`. Returns the decoded
/// JSON (a Map or a List) or throws [ApiException].
class ApiClient {
  /// Set in main(): signs in again with the saved credentials when the
  /// Supabase session can no longer be refreshed. Returns true on success.
  static Future<bool> Function()? onSessionLost;
  static bool _recovering = false;

  Future<dynamic> get(String path, {Map<String, String>? query}) => _call(HttpMethod.get, path, query: query);
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) => _call(HttpMethod.post, path, body: body);
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) => _call(HttpMethod.patch, path, body: body);
  Future<dynamic> delete(String path) => _call(HttpMethod.delete, path);

  Future<dynamic> _call(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool retried = false,
  }) async {
    try {
      final response = await supabaseInstance.functions.invoke(
        path,
        method: method,
        body: body,
        queryParameters: query,
      );
      return response.data;
    } on FunctionException catch (e) {
      // An expired access token: renew it with the stored refresh token and
      // try once more, instead of sending the user back to the login screen.
      if (e.status == 401 && !retried && supabaseInstance.auth.currentSession != null) {
        try {
          await supabaseInstance.auth.refreshSession();
          return _call(method, path, body: body, query: query, retried: true);
        } catch (_) {
          // refresh failed: try the saved credentials before giving up
          final recover = onSessionLost;
          if (recover != null && !_recovering) {
            _recovering = true;
            try {
              if (await recover()) return _call(method, path, body: body, query: query, retried: true);
            } finally {
              _recovering = false;
            }
          }
        }
      }
      final details = e.details;
      var message = '';
      if (details is Map && details['error'] is Map) {
        message = '${details['error']['message'] ?? ''}';
      }
      throw ApiException(e.status, message);
    } catch (_) {
      throw const ApiException(null, 'network');
    }
  }
}
