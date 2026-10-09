import '../../domain/entities/login_response_entity.dart';

class LoginResponseModel {
  const LoginResponseModel({required this.message, required this.token});

  final String message;
  final String token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final token = json['token'];

    if (message != null && message is! String) {
      throw const FormatException('Login response message must be a string.');
    }

    if (token is! String || token.trim().isEmpty) {
      throw const FormatException(
        'Login response must contain a non-empty token.',
      );
    }

    return LoginResponseModel(
      message: (message as String?) ?? '',
      token: token,
    );
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(message: message, token: token);
  }
}
