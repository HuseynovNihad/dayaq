import 'package:equatable/equatable.dart';

enum ProfileContentType { about, termConditions, rules }

sealed class ProfileContentEvent extends Equatable {
  const ProfileContentEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileContentRequested extends ProfileContentEvent {
  const ProfileContentRequested(this.type);

  final ProfileContentType type;

  @override
  List<Object?> get props => [type];
}

final class ProfileContentRefreshed extends ProfileContentEvent {
  const ProfileContentRefreshed();
}
