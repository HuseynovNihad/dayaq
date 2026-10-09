import 'package:equatable/equatable.dart';

enum FailureKind {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cancelled,
  unknown,
}

class AppFailure extends Equatable {
  const AppFailure(
    this.message, {
    this.kind = FailureKind.unknown,
    this.statusCode,
  });
  final String message;
  final FailureKind kind;
  final int? statusCode;
  @override
  List<Object?> get props => [message, kind, statusCode];
}
