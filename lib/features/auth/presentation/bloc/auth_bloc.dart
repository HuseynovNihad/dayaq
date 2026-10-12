import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase loginUseCase, required Logout logout})
    : _loginUseCase = loginUseCase,
      _logout = logout,
      super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _loginUseCase;
  final Logout _logout;

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoginLoading ||
        state is AuthLoginSuccess ||
        state is AuthLogoutLoading) {
      return;
    }

    final email = event.email.trim();
    final password = event.password;

    if (email.isEmpty || password.isEmpty) {
      emit(
        const AuthLoginFailure(
          failure: AppFailure(
            'E-poçt və şifrənizi daxil edin.',
            kind: FailureKind.validation,
          ),
        ),
      );
      return;
    }

    emit(const AuthLoginLoading());

    try {
      final result = await _loginUseCase(email: email, password: password);

      if (emit.isDone) return;

      switch (result) {
        case Success(data: final response):
          emit(AuthLoginSuccess(response: response));

        case Failure(error: final failure):
          emit(AuthLoginFailure(failure: failure));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      if (emit.isDone) return;

      emit(
        const AuthLoginFailure(
          failure: AppFailure(
            'Giriş zamanı xəta baş verdi. Yenidən cəhd edin.',
            kind: FailureKind.unknown,
          ),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLogoutLoading) return;

    emit(const AuthLogoutLoading());

    try {
      final result = await _logout();

      if (emit.isDone) return;

      switch (result) {
        case Success():
          emit(const AuthLogoutSuccess());

        case Failure(error: final failure):
          emit(AuthLogoutFailure(failure: failure));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      if (emit.isDone) return;

      emit(
        const AuthLogoutFailure(
          failure: AppFailure(
            'Sistemdən çıxış zamanı xəta baş verdi.',
            kind: FailureKind.unknown,
          ),
        ),
      );
    }
  }
}
