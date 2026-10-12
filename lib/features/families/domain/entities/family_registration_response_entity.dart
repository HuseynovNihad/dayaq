import 'package:equatable/equatable.dart';

class FamilyRegistrationResponseEntity extends Equatable {
  const FamilyRegistrationResponseEntity({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
