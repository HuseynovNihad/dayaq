import 'package:equatable/equatable.dart';

import '../../../families/domain/entities/family_entity.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.totalFamilies,
    required this.monthlyRegistrations,
    required this.recentFamilies,
    required this.families,
  });

  final int totalFamilies;
  final int monthlyRegistrations;
  final List<FamilyEntity> recentFamilies;
  final List<FamilyEntity> families;

  @override
  List<Object?> get props => [
    totalFamilies,
    monthlyRegistrations,
    recentFamilies,
    families,
  ];
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
