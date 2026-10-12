import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../data/models/family_registration_request_model.dart';
import '../../domain/usecases/register_family.dart';

part 'families_event.dart';
part 'families_state.dart';

class FamiliesBloc extends Bloc<FamiliesEvent, FamiliesState> {
  FamiliesBloc({required this._registerFamily})
    : super(const FamiliesInitial()) {
    on<RegisterFamilyEvent>(_onRegisterFamily);
    on<ResetFamilyRegistrationEvent>(_onResetRegistration);
  }

  final RegisterFamily _registerFamily;

  bool _isSubmitting = false;

  Future<void> _onRegisterFamily(
    RegisterFamilyEvent event,
    Emitter<FamiliesState> emit,
  ) async {
    if (_isSubmitting || state is FamilyRegistrationSuccess) {
      return;
    }

    _isSubmitting = true;
    emit(const FamilyRegistrationLoading());

    try {
      final response = await _registerFamily(event.request);

      emit(FamilyRegistrationSuccess(message: response.message));
    } on AppFailure catch (error) {
      emit(FamilyRegistrationFailure(message: error.message));
    } catch (_) {
      emit(
        const FamilyRegistrationFailure(
          message: 'Ailə qeydiyyatı zamanı gözlənilməz xəta baş verdi.',
        ),
      );
    } finally {
      _isSubmitting = false;
    }
  }

  void _onResetRegistration(
    ResetFamilyRegistrationEvent event,
    Emitter<FamiliesState> emit,
  ) {
    if (_isSubmitting) return;

    emit(const FamiliesInitial());
  }
}
