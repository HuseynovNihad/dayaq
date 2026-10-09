import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  const LoginResponseEntity({
    required this.message,
    required this.token,
  });

  final String message;
  final String token;

  @override
  List<Object?> get props => [message, token];

  @override
  bool get stringify => false;
}