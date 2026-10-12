import 'package:equatable/equatable.dart';

import '../../domain/entities/family_details_entity.dart';

sealed class FamilyDetailsState extends Equatable {
  const FamilyDetailsState();

  @override
  List<Object?> get props => [];
}

final class FamilyDetailsInitial extends FamilyDetailsState {
  const FamilyDetailsInitial();
}

final class FamilyDetailsLoading extends FamilyDetailsState {
  const FamilyDetailsLoading();
}

final class FamilyDetailsLoaded extends FamilyDetailsState {
  const FamilyDetailsLoaded({required this.details, this.isRefreshing = false});

  final FamilyDetailsEntity details;
  final bool isRefreshing;

  FamilyDetailsLoaded copyWith({
    FamilyDetailsEntity? details,
    bool? isRefreshing,
  }) {
    return FamilyDetailsLoaded(
      details: details ?? this.details,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [details, isRefreshing];
}

final class FamilyDetailsError extends FamilyDetailsState {
  const FamilyDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
