import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/usecases/get_about.dart';
import '../../domain/usecases/get_term_conditions.dart';
import '../../domain/usecases/get_rules.dart';
import 'profile_content_event.dart';
import 'profile_content_state.dart';

class ProfileContentBloc
    extends Bloc<ProfileContentEvent, ProfileContentState> {
  ProfileContentBloc({
    required this._getAbout,
    required this._getTermConditions,
    required this._getRules,
  }) : super(const ProfileContentInitial()) {
    on<ProfileContentRequested>(_onRequested);
    on<ProfileContentRefreshed>(_onRefreshed);
  }

  final GetAbout _getAbout;
  final GetTermConditions _getTermConditions;
  final GetRules _getRules;

  ProfileContentType? _currentType;
  bool _isLoading = false;

  Future<void> _onRequested(
    ProfileContentRequested event,
    Emitter<ProfileContentState> emit,
  ) async {
    if (_isLoading) return;

    _currentType = event.type;
    await _loadContent(emit, type: event.type, refresh: false);
  }

  Future<void> _onRefreshed(
    ProfileContentRefreshed event,
    Emitter<ProfileContentState> emit,
  ) async {
    if (_isLoading || _currentType == null) return;

    await _loadContent(emit, type: _currentType!, refresh: true);
  }

  Future<void> _loadContent(
    Emitter<ProfileContentState> emit, {
    required ProfileContentType type,
    required bool refresh,
  }) async {
    _isLoading = true;
    final previousState = state;

    if (refresh &&
        previousState is ProfileContentLoaded &&
        previousState.type == type) {
      emit(previousState.copyWith(isRefreshing: true));
    } else {
      emit(ProfileContentLoading(type));
    }

    try {
      final result = switch (type) {
        ProfileContentType.about => ProfileContentLoaded(
          type: type,
          about: await _getAbout(),
        ),
        ProfileContentType.termConditions => ProfileContentLoaded(
          type: type,
          termConditions: await _getTermConditions(),
        ),
        ProfileContentType.rules => ProfileContentLoaded(
          type: type,
          rules: await _getRules(),
        ),
      };

      emit(result);
    } on AppFailure catch (error) {
      if (refresh &&
          previousState is ProfileContentLoaded &&
          previousState.type == type) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(ProfileContentError(type: type, message: error.message));
      }
    } catch (_) {
      if (refresh &&
          previousState is ProfileContentLoaded &&
          previousState.type == type) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(
          ProfileContentError(
            type: type,
            message: 'Məlumatları yükləmək mümkün olmadı.',
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }
}
