import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this._loginUseCase}) : super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoginLoading || state is AuthLoginSuccess) {
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
}
