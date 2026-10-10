import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../../families/domain/entities/family_entity.dart';
import '../../../families/domain/usecases/get_families.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetFamilies getFamilies})
    : _getFamilies = getFamilies,
      super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
  }

  final GetFamilies _getFamilies;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    await _loadFamilies(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await _loadFamilies(emit);
  }

  Future<void> _loadFamilies(Emitter<HomeState> emit) async {
    try {
      final families = await _getFamilies();

      final sortedFamilies = List<FamilyEntity>.from(families)
        ..sort((a, b) {
          final first = a.createdAt;
          final second = b.createdAt;

          if (first == null && second == null) return 0;
          if (first == null) return 1;
          if (second == null) return -1;

          return second.compareTo(first);
        });

      final now = DateTime.now();

      final monthlyRegistrations = families.where((family) {
        final date = family.createdAt;

        if (date == null) return false;

        return date.year == now.year && date.month == now.month;
      }).length;

      final recentFamilies = sortedFamilies.take(5).toList(growable: false);

      emit(
        HomeLoaded(
          totalFamilies: families.length,
          monthlyRegistrations: monthlyRegistrations,
          recentFamilies: recentFamilies,
          families: List.unmodifiable(sortedFamilies),
        ),
      );
    } on AppFailure catch (error) {
      emit(HomeError(error.message));
    } catch (_) {
      emit(const HomeError('Məlumatlar yüklənərkən xəta baş verdi.'));
    }
  }
}
