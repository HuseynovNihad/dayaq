
import 'package:equatable/equatable.dart';

import '../../domain/entities/family_entity.dart';
import 'families_list_event.dart';

sealed class FamiliesListState extends Equatable {
  const FamiliesListState();

  @override
  List<Object?> get props => [];
}

final class FamiliesListInitial extends FamiliesListState {
  const FamiliesListInitial();
}

final class FamiliesListLoading extends FamiliesListState {
  const FamiliesListLoading();
}

final class FamiliesListLoaded extends FamiliesListState {
  const FamiliesListLoaded({
    required this.allFamilies,
    required this.filteredFamilies,
    required this.regions,
    this.searchQuery = '',
    this.selectedRegion,
    this.sort = FamiliesSort.newest,
    this.isRefreshing = false,
  });

  final List<FamilyEntity> allFamilies;
  final List<FamilyEntity> filteredFamilies;
  final List<String> regions;
  final String searchQuery;
  final String? selectedRegion;
  final FamiliesSort sort;
  final bool isRefreshing;

  int get totalFamilies => allFamilies.length;

  int get visibleFamilies => filteredFamilies.length;

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty || selectedRegion != null;

  FamiliesListLoaded copyWith({
    List<FamilyEntity>? allFamilies,
    List<FamilyEntity>? filteredFamilies,
    List<String>? regions,
    String? searchQuery,
    String? selectedRegion,
    bool clearRegion = false,
    FamiliesSort? sort,
    bool? isRefreshing,
  }) {
    return FamiliesListLoaded(
      allFamilies: allFamilies ?? this.allFamilies,
      filteredFamilies: filteredFamilies ?? this.filteredFamilies,
      regions: regions ?? this.regions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRegion: clearRegion
          ? null
          : selectedRegion ?? this.selectedRegion,
      sort: sort ?? this.sort,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allFamilies,
    filteredFamilies,
    regions,
    searchQuery,
    selectedRegion,
    sort,
    isRefreshing,
  ];
}

final class FamiliesListError extends FamiliesListState {
  const FamiliesListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
