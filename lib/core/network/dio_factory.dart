import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

Dio createDio(AppConfig config, {required TokenStorage tokenStorage}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.hasApiUrl ? config.apiBaseUrl : '',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (!config.hasApiUrl) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: StateError(
                'API_BASE_URL must be configured before API requests.',
              ),
            ),
          );
          return;
        }

        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage));

  return dio;
}
