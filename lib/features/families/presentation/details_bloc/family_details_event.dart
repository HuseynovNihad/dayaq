import 'package:equatable/equatable.dart';

sealed class FamilyDetailsEvent extends Equatable {
  const FamilyDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class FamilyDetailsStarted extends FamilyDetailsEvent {
  const FamilyDetailsStarted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

final class FamilyDetailsRefreshed extends FamilyDetailsEvent {
  const FamilyDetailsRefreshed();
}
