part of 'families_bloc.dart';

sealed class FamiliesEvent extends Equatable {
  const FamiliesEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterFamilyEvent extends FamiliesEvent {
  const RegisterFamilyEvent({required this.request});

  final FamilyRegistrationRequestModel request;

  @override
  List<Object?> get props => [request];
}

final class ResetFamilyRegistrationEvent extends FamiliesEvent {
  const ResetFamilyRegistrationEvent();
}
