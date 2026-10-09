import 'package:dio/dio.dart';

import '../error/app_failure.dart';

AppFailure mapDioFailure(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const AppFailure(
        'Sorğunun vaxtı bitdi. Yenidən cəhd edin.',
        kind: FailureKind.timeout,
      );

    case DioExceptionType.connectionError:
      return const AppFailure(
        'İnternet bağlantısını yoxlayın.',
        kind: FailureKind.network,
      );

    case DioExceptionType.cancel:
      return const AppFailure(
        'Sorğu ləğv edildi.',
        kind: FailureKind.cancelled,
      );

    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;

      switch (status) {
        case 401:
          return AppFailure(
            'Hesabınıza yenidən daxil olun.',
            kind: FailureKind.unauthorized,
            statusCode: status,
          );

        case 403:
          return AppFailure(
            'Bu əməliyyat üçün icazəniz yoxdur.',
            kind: FailureKind.forbidden,
            statusCode: status,
          );

        case 404:
          return AppFailure(
            'Məlumat tapılmadı.',
            kind: FailureKind.notFound,
            statusCode: status,
          );

        case 400:
        case 422:
          return AppFailure(
            'Daxil etdiyiniz məlumatları yoxlayın.',
            kind: FailureKind.validation,
            statusCode: status,
          );

        default:
          return AppFailure(
            'Sorğu yerinə yetirilmədi. Yenidən cəhd edin.',
            kind: FailureKind.server,
            statusCode: status,
          );
      }

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const AppFailure(
        'Bağlantı qurulmadı. Yenidən cəhd edin.',
        kind: FailureKind.unknown,
      );
  }
}
