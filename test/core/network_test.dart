import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dayaq/core/config/app_config.dart';
import 'package:dayaq/core/error/app_failure.dart';
import 'package:dayaq/core/network/dio_factory.dart';
import 'package:dayaq/core/network/dio_failure_mapper.dart';

void main() {
  test('Missing API URL rejects requests with configuration error', () async {
    final dio = createDio(const AppConfig(apiBaseUrl: ''));
    addTearDown(() => dio.close(force: true));
    await expectLater(
      dio.get<dynamic>('/campaigns'),
      throwsA(
        isA<DioException>().having(
          (e) => e.error,
          'configuration error',
          isA<StateError>(),
        ),
      ),
    );
  });

  test('Unauthorized response maps to domain failure without raw response', () {
    final request = RequestOptions(path: '/profile');
    final failure = mapDioFailure(
      DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: request,
          statusCode: 401,
          data: {'secret': 'private'},
        ),
      ),
    );
    expect(failure.kind, FailureKind.unauthorized);
    expect(failure.statusCode, 401);
    expect(failure.message, isNot(contains('private')));
  });

  test('Timeout maps to retryable timeout category', () {
    final failure = mapDioFailure(
      DioException(
        requestOptions: RequestOptions(path: '/campaigns'),
        type: DioExceptionType.receiveTimeout,
      ),
    );
    expect(failure.kind, FailureKind.timeout);
  });
}
