import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  }) : _remoteDataSource = remoteDataSource,
       _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Result<LoginResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(email: email, password: password);

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
}
