import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/entities/family_entity.dart';
import '../../domain/usecases/get_families.dart';
import 'families_list_event.dart';
import 'families_list_state.dart';

class FamiliesListBloc extends Bloc<FamiliesListEvent, FamiliesListState> {
  FamiliesListBloc({required this._getFamilies})
    : super(const FamiliesListInitial()) {
    on<FamiliesListStarted>(_onStarted);
    on<FamiliesListRefreshed>(_onRefreshed);
    on<FamiliesListSearchChanged>(_onSearchChanged);
    on<FamiliesListRegionChanged>(_onRegionChanged);
    on<FamiliesListSortChanged>(_onSortChanged);
  }

  final GetFamilies _getFamilies;

  bool _isLoading = false;

  String _searchQuery = '';
  String? _selectedRegion;
  FamiliesSort _sort = FamiliesSort.newest;

  Future<void> _onStarted(
    FamiliesListStarted event,
    Emitter<FamiliesListState> emit,
  ) async {
    if (_isLoading) return;
    await _loadFamilies(emit, showLoading: true);
  }

  Future<void> _onRefreshed(
    FamiliesListRefreshed event,
    Emitter<FamiliesListState> emit,
  ) async {
    if (_isLoading) return;
    await _loadFamilies(emit, showLoading: false);
  }

  Future<void> _loadFamilies(
    Emitter<FamiliesListState> emit, {
    required bool showLoading,
  }) async {
    if (_isLoading) return;

    _isLoading = true;

    final previousState = state;
    final previousLoaded = previousState is FamiliesListLoaded
        ? previousState
        : null;

    if (showLoading && previousLoaded == null) {
      emit(const FamiliesListLoading());
    } else if (previousLoaded != null) {
      emit(previousLoaded.copyWith(isRefreshing: true));
    } else {
      emit(const FamiliesListLoading());
    }

    try {
      final families = await _getFamilies();

      final allFamilies = List<FamilyEntity>.unmodifiable(families);

      final regions =
          allFamilies
              .map((family) => family.region.trim())
              .where((region) => region.isNotEmpty)
              .toSet()
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      if (_selectedRegion != null && !regions.contains(_selectedRegion)) {
        _selectedRegion = null;
      }

      emit(
        FamiliesListLoaded(
          allFamilies: allFamilies,
          filteredFamilies: _filterAndSort(allFamilies),
          regions: List.unmodifiable(regions),
          searchQuery: _searchQuery,
          selectedRegion: _selectedRegion,
          sort: _sort,
        ),
      );
    } on AppFailure catch (error) {
      _emitLoadError(emit, error.message, previousLoaded);
    } catch (_) {
      _emitLoadError(
        emit,
        'Ailələr yüklənərkən gözlənilməz xəta baş verdi.',
        previousLoaded,
      );
    } finally {
      _isLoading = false;
    }
  }

  void _emitLoadError(
    Emitter<FamiliesListState> emit,
    String message,
    FamiliesListLoaded? previousLoaded,
  ) {
    if (previousLoaded != null) {
      emit(
        previousLoaded.copyWith(
          filteredFamilies: _filterAndSort(previousLoaded.allFamilies),
          searchQuery: _searchQuery,
          selectedRegion: _selectedRegion,
          sort: _sort,
          isRefreshing: false,
        ),
      );
    } else {
      emit(FamiliesListError(message));
    }
  }

  void _onSearchChanged(
    FamiliesListSearchChanged event,
    Emitter<FamiliesListState> emit,
  ) {
    _searchQuery = event.query;

    final currentState = state;

    if (currentState is! FamiliesListLoaded) return;

    emit(
      currentState.copyWith(
        searchQuery: _searchQuery,
        filteredFamilies: _filterAndSort(currentState.allFamilies),
      ),
    );
  }

  void _onRegionChanged(
    FamiliesListRegionChanged event,
    Emitter<FamiliesListState> emit,
  ) {
    _selectedRegion = event.region == null || event.region!.trim().isEmpty
        ? null
        : event.region!.trim();

    final currentState = state;

    if (currentState is! FamiliesListLoaded) return;

    emit(
      currentState.copyWith(
        selectedRegion: _selectedRegion,
        clearRegion: _selectedRegion == null,
        filteredFamilies: _filterAndSort(currentState.allFamilies),
      ),
    );
  }

  void _onSortChanged(
    FamiliesListSortChanged event,
    Emitter<FamiliesListState> emit,
  ) {
    _sort = event.sort;

    final currentState = state;

    if (currentState is! FamiliesListLoaded) return;

    emit(
      currentState.copyWith(
        sort: _sort,
        filteredFamilies: _filterAndSort(currentState.allFamilies),
      ),
    );
  }

  List<FamilyEntity> _filterAndSort(List<FamilyEntity> families) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = families.where((family) {
      final matchesSearch =
          query.isEmpty ||
          family.nameSurname.toLowerCase().contains(query) ||
          family.registerNumber.toLowerCase().contains(query);

      final matchesRegion =
          _selectedRegion == null ||
          family.region.trim().toLowerCase() == _selectedRegion!.toLowerCase();

      return matchesSearch && matchesRegion;
    }).toList();

    switch (_sort) {
      case FamiliesSort.newest:
        filtered.sort((a, b) => _compareDates(a.createdAt, b.createdAt));
        break;
      case FamiliesSort.oldest:
        filtered.sort((a, b) => _compareDates(b.createdAt, a.createdAt));
        break;
      case FamiliesSort.nameAZ:
        filtered.sort(
          (a, b) => a.nameSurname.toLowerCase().compareTo(
            b.nameSurname.toLowerCase(),
          ),
        );
        break;
      case FamiliesSort.nameZA:
        filtered.sort(
          (a, b) => b.nameSurname.toLowerCase().compareTo(
            a.nameSurname.toLowerCase(),
          ),
        );
        break;
    }

    return List.unmodifiable(filtered);
  }

  int _compareDates(DateTime? first, DateTime? second) {
    if (first == null && second == null) return 0;
    if (first == null) return 1;
    if (second == null) return -1;
    return second.compareTo(first);
  }
}
