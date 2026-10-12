import 'package:equatable/equatable.dart';

enum FamiliesSort { newest, oldest, nameAZ, nameZA }

sealed class FamiliesListEvent extends Equatable {
  const FamiliesListEvent();

  @override
  List<Object?> get props => [];
}

final class FamiliesListStarted extends FamiliesListEvent {
  const FamiliesListStarted();
}

final class FamiliesListRefreshed extends FamiliesListEvent {
  const FamiliesListRefreshed();
}

final class FamiliesListSearchChanged extends FamiliesListEvent {
  const FamiliesListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class FamiliesListRegionChanged extends FamiliesListEvent {
  const FamiliesListRegionChanged(this.region);

  final String? region;

  @override
  List<Object?> get props => [region];
}

final class FamiliesListSortChanged extends FamiliesListEvent {
  const FamiliesListSortChanged(this.sort);

  final FamiliesSort sort;

  @override
  List<Object?> get props => [sort];
}
