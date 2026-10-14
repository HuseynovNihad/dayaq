class LoginRequestModel {
  const LoginRequestModel({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  final String email;
  final String password;
  final String? fcmToken;

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'password': password,
      if (fcmToken != null && fcmToken!.isNotEmpty) 'fcm_token': fcmToken,
    };
  }
}
