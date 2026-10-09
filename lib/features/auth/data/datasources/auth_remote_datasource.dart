import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post<dynamic>(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Login response must be a JSON object.');
    }

    return LoginResponseModel.fromJson(data);
  }
}
