import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/usecases/get_family_details.dart';
import 'family_details_event.dart';
import 'family_details_state.dart';

class FamilyDetailsBloc extends Bloc<FamilyDetailsEvent, FamilyDetailsState> {
  FamilyDetailsBloc({required this._getFamilyDetails})
    : super(const FamilyDetailsInitial()) {
    on<FamilyDetailsStarted>(_onStarted);
    on<FamilyDetailsRefreshed>(_onRefreshed);
  }

  final GetFamilyDetails _getFamilyDetails;
  int? _familyId;
  bool _isLoading = false;

  Future<void> _onStarted(
    FamilyDetailsStarted event,
    Emitter<FamilyDetailsState> emit,
  ) async {
    if (_isLoading) return;

    _familyId = event.id;
    await _loadDetails(emit, showLoading: true);
  }

  Future<void> _onRefreshed(
    FamilyDetailsRefreshed event,
    Emitter<FamilyDetailsState> emit,
  ) async {
    if (_isLoading || _familyId == null) return;

    await _loadDetails(emit, showLoading: false);
  }

  Future<void> _loadDetails(
    Emitter<FamilyDetailsState> emit, {
    required bool showLoading,
  }) async {
    final id = _familyId;
    if (id == null || _isLoading) return;

    _isLoading = true;
    final previousState = state;

    if (showLoading || previousState is! FamilyDetailsLoaded) {
      emit(const FamilyDetailsLoading());
    } else {
      emit(previousState.copyWith(isRefreshing: true));
    }

    try {
      final details = await _getFamilyDetails(id);

      emit(FamilyDetailsLoaded(details: details));
    } on AppFailure catch (error) {
      if (previousState is FamilyDetailsLoaded) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(FamilyDetailsError(error.message));
      }
    } catch (_) {
      if (previousState is FamilyDetailsLoaded) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(
          const FamilyDetailsError(
            'Ailə məlumatlarını yükləmək mümkün olmadı.',
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }
}
