import '../../../core/utils/json_utils.dart';

class ProfileModel {
  final String id;
  final String role; // customer | marketer
  final String fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final double? rating;
  final int reviewsCount;

  const ProfileModel({
    required this.id,
    required this.role,
    required this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.rating,
    this.reviewsCount = 0,
  });

  /// Works for the full profile (`auth/me`) and for the small embeds
  /// (`{id, full_name, avatar_url}`) used inside requests, offers and chats.
  factory ProfileModel.fromJson(Map<String, dynamic> j) => ProfileModel(
        id: '${j['id']}',
        role: '${j['role'] ?? ''}',
        fullName: '${j['full_name'] ?? ''}',
        email: j['email'] as String?,
        phone: j['phone'] as String?,
        avatarUrl: j['avatar_url'] as String?,
        bio: j['bio'] as String?,
        rating: toDouble(j['rating']),
        reviewsCount: toInt(j['reviews_count']) ?? 0,
      );
}
