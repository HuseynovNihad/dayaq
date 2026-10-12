part of 'families_bloc.dart';

sealed class FamiliesState extends Equatable {
  const FamiliesState();

  @override
  List<Object?> get props => [];
}

final class FamiliesInitial extends FamiliesState {
  const FamiliesInitial();
}

final class FamilyRegistrationLoading extends FamiliesState {
  const FamilyRegistrationLoading();
}

final class FamilyRegistrationSuccess extends FamiliesState {
  const FamilyRegistrationSuccess({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class FamilyRegistrationFailure extends FamiliesState {
  const FamilyRegistrationFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
