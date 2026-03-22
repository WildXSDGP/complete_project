class UserModel {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final AuthType authType;

  const UserModel({
    required this.id,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    required this.authType,
  });
}

enum AuthType { email, phone, google }
