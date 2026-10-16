import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(
        headers: {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Login response must be a JSON object.');
    }

    return LoginResponseModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await _dio.post<void>(
      ApiEndpoints.logout,
      options: Options(
        headers: {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
      ),
    );
  }
}
