import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Login sorğusuna token əlavə etmirik.
      if (options.path == '/api/login') {
        handler.next(options);
        return;
      }

      final token = await _tokenStorage.getToken();

      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
