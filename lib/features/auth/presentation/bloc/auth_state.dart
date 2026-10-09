part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => false;
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

final class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess({required this.response});

  final LoginResponseEntity response;

  @override
  List<Object?> get props => [response];
}

final class AuthLoginFailure extends AuthState {
  const AuthLoginFailure({required this.failure});

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
