import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final stopwatch = Stopwatch()..start();

    // Tam request URL-ni formalaşdırır.
    final requestUri = _dio.options.baseUrl.isEmpty
        ? Uri.parse(ApiEndpoints.login)
        : Uri.parse(_dio.options.baseUrl).resolve(ApiEndpoints.login);

    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ LOGIN REQUEST ━━━━━━━━━━');
      debugPrint('🌐 Base URL: ${_dio.options.baseUrl}');
      debugPrint('🔗 Endpoint: ${ApiEndpoints.login}');
      debugPrint('🌐 Request URL: $requestUri');
      debugPrint('📤 Method: POST');
      debugPrint('📦 Content-Type: application/json');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.login,
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,

          // Redirect-i avtomatik izləməsin.
          // 302 cavabının Location header-ini yoxlayaq.
          followRedirects: false,

          // 302 DioException kimi qaytarılacaq.
          validateStatus: (status) {
            return status != null && status >= 200 && status < 300;
          },
        ),
      );

      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ LOGIN RESPONSE ━━━━━━━━━━');
        debugPrint('✅ HTTP Status: ${response.statusCode}');
        debugPrint('🌐 Request URL: ${response.requestOptions.uri}');
        debugPrint('⏱ Duration: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('📥 Response type: ${response.data.runtimeType}');
      }

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Login response must be a JSON object.');
      }

      final result = LoginResponseModel.fromJson(data);

      if (kDebugMode) {
        debugPrint('✅ Login response parsed successfully');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      return result;
    } on DioException catch (e) {
      stopwatch.stop();

      if (kDebugMode) {
        final response = e.response;
        final statusCode = response?.statusCode;
        final location = response?.headers.value('location');

        debugPrint('━━━━━━━━━━ LOGIN ERROR ━━━━━━━━━━');
        debugPrint('❌ Dio error type: ${e.type}');
        debugPrint('🌐 Request URL: ${e.requestOptions.uri}');
        debugPrint('📡 HTTP Status: ${statusCode ?? "N/A"}');
        debugPrint('🔀 Redirect Location: ${location ?? "N/A"}');
        debugPrint('⏱ Duration: ${stopwatch.elapsedMilliseconds} ms');

        if (statusCode == 301 ||
            statusCode == 302 ||
            statusCode == 303 ||
            statusCode == 307 ||
            statusCode == 308) {
          debugPrint('⚠️ Server redirect cavabı qaytardı.');
          debugPrint('⚠️ Location ünvanını yoxlayın.');
        }

        if (statusCode == 401) {
          debugPrint('⚠️ Unauthorized (401).');
        }

        if (statusCode == 403) {
          debugPrint('⚠️ Forbidden (403).');
        }

        if (statusCode == 404) {
          debugPrint('⚠️ Endpoint tapılmadı (404).');
        }

        if (statusCode != null && statusCode >= 500) {
          debugPrint('⚠️ Server xətası ($statusCode).');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    } on FormatException catch (e) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ LOGIN PARSE ERROR ━━━━━━━━━━');
        debugPrint('❌ ${e.message}');
        debugPrint('⏱ Duration: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    } catch (e) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ LOGIN ERROR ━━━━━━━━━━');
        debugPrint('❌ Error type: ${e.runtimeType}');
        debugPrint('⏱ Duration: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    }
  }
}
