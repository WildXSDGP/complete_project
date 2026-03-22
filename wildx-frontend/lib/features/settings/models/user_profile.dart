// lib/models/user_profile.dart

class UserProfile {
  final String displayName;
  final String email;
  final String badge;
  final String? avatarUrl;

  const UserProfile({
    required this.displayName,
    required this.email,
    required this.badge,
    this.avatarUrl,
  });
}