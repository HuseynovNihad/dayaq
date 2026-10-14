import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/token_storage.dart';

import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._tokenStorage,
    required this._notificationService,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  final NotificationService _notificationService;

  @override
  Future<Result<LoginResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      String? fcmToken;

      try {
        fcmToken = await _notificationService.getToken();
      } catch (_) {
        fcmToken = null;
      }

      final request = LoginRequestModel(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      final response = await _remoteDataSource.login(request);

      await _tokenStorage.saveToken(response.token);
      await _tokenStorage.saveEmail(email);

      return Success<LoginResponseEntity>(response.toEntity());
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        return const Failure<LoginResponseEntity>(
          AppFailure(
            'E-poçt və ya şifrə yanlışdır.',
            kind: FailureKind.unauthorized,
            statusCode: 401,
          ),
        );
      }

      return Failure<LoginResponseEntity>(mapDioFailure(error));
    } on FormatException {
      return const Failure<LoginResponseEntity>(
        AppFailure(
          'Serverdən gələn cavab gözlənilən formatda deyil.',
          kind: FailureKind.server,
        ),
      );
    } catch (_) {
      return const Failure<LoginResponseEntity>(
        AppFailure(
          'Giriş məlumatları saxlanılarkən xəta baş verdi.',
          kind: FailureKind.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();

      await _tokenStorage.clearSession();

      return const Success<void>(null);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        try {
          await _tokenStorage.clearSession();
          return const Success<void>(null);
        } catch (_) {
          return const Failure<void>(
            AppFailure(
              'Sessiya məlumatlarını silmək mümkün olmadı.',
              kind: FailureKind.unknown,
            ),
          );
        }
      }

      return Failure<void>(mapDioFailure(error));
    } catch (_) {
      return const Failure<void>(
        AppFailure(
          'Sistemdən çıxış zamanı xəta baş verdi.',
          kind: FailureKind.unknown,
        ),
      );
    }
  }
}
