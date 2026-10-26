import 'user_role.dart';

/// The signed-in account, as returned by `auth/login` and `auth/signup`.
class AuthUser {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final UserRole role;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.role,
    this.email,
    this.phone,
  });

  static UserRole roleFrom(Object? value) => value == 'marketer' ? UserRole.marketer : UserRole.client;
}
