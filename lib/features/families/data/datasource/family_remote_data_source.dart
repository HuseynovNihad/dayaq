import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/family_details_model.dart';
import '../models/family_model.dart';
import '../models/family_registration_request_model.dart';
import '../models/family_registration_response_model.dart';

abstract interface class FamilyRemoteDataSource {
  Future<List<FamilyModel>> getFamilies();

  Future<FamilyDetailsModel> getFamilyDetails(int id);

  Future<FamilyRegistrationResponseModel> registerFamily(
    FamilyRegistrationRequestModel request,
  );
}

class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  FamilyRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FamilyModel>> getFamilies() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.families);
    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Invalid families response format.');
    }

    final data = responseData['data'];

    if (data is! List) {
      throw const FormatException('Families data must be a JSON array.');
    }

    final families = <FamilyModel>[];

    for (var index = 0; index < data.length; index++) {
      final item = data[index];

      if (item is! Map<String, dynamic>) {
        throw FormatException('Invalid family data at index $index.');
      }

      families.add(FamilyModel.fromJson(item));
    }

    return families;
  }

  @override
  Future<FamilyDetailsModel> getFamilyDetails(int id) async {
    if (id <= 0) {
      throw const FormatException('Invalid family registration ID.');
    }

    final endpoint = ApiEndpoints.familyDetails(id);

    final response = await _dio.get<dynamic>(endpoint);
    final responseData = response.data;

    late final Map<String, dynamic> detailsJson;

    if (responseData is List) {
      if (responseData.isEmpty) {
        throw const FormatException('Family details response is empty.');
      }

      final firstItem = responseData.first;

      if (firstItem is! Map) {
        throw const FormatException('Invalid family details array item.');
      }

      detailsJson = Map<String, dynamic>.from(firstItem);
    } else if (responseData is Map) {
      final json = Map<String, dynamic>.from(responseData);
      final nestedData = json['data'];

      if (nestedData is List) {
        if (nestedData.isEmpty || nestedData.first is! Map) {
          throw const FormatException('Invalid family details data array.');
        }

        detailsJson = Map<String, dynamic>.from(nestedData.first as Map);
      } else if (nestedData is Map) {
        detailsJson = Map<String, dynamic>.from(nestedData);
      } else if (json.containsKey('region') ||
          json.containsKey('members') ||
          json.containsKey('monthly_income')) {
        detailsJson = json;
      } else {
        throw const FormatException(
          'Invalid family details response structure.',
        );
      }
    } else {
      throw const FormatException('Invalid family details response format.');
    }

    return FamilyDetailsModel.fromJson(detailsJson);
  }

  @override
  Future<FamilyRegistrationResponseModel> registerFamily(
    FamilyRegistrationRequestModel request,
  ) async {
    final stopwatch = Stopwatch()..start();

    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ FAMILY REGISTRATION REQUEST ━━━━━━━━━━');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: ${ApiEndpoints.registerFamily}');
      debugPrint('BASE URL: ${_dio.options.baseUrl}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    try {
      final formData = await request.toFormData();

      if (kDebugMode) {
        debugPrint('CONTENT TYPE: multipart/form-data');

        for (final field in formData.fields) {
          if (field.key.toLowerCase().contains('password') ||
              field.key.toLowerCase().contains('token') ||
              field.key.toLowerCase().contains('fin') ||
              field.key.toLowerCase().contains('phone') ||
              field.key.toLowerCase().contains('seria') ||
              field.key.toLowerCase().contains('name') ||
              field.key.toLowerCase().contains('surname') ||
              field.key.toLowerCase().contains('address') ||
              field.key.toLowerCase().contains('note')) {
            debugPrint('${field.key}: [REDACTED]');
          } else {
            debugPrint('${field.key}: ${field.value}');
          }
        }

        for (final file in formData.files) {
          debugPrint('FILE FIELD: ${file.key}');
          debugPrint('FILE NAME: [REDACTED]');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      final response = await _dio.post<dynamic>(
        ApiEndpoints.registerFamily,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY REGISTRATION RESPONSE ━━━━━━━━━━');
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('REQUEST URL: ${response.requestOptions.uri}');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('RESPONSE TYPE: ${response.data.runtimeType}');

        if (response.data is Map) {
          final data = response.data as Map;
          debugPrint('RESPONSE KEYS: ${data.keys.toList()}');
          debugPrint('SUCCESS: ${data['success']}');
          debugPrint('MESSAGE: ${data['message']}');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException(
          'Family registration response must be a JSON object.',
        );
      }

      return FamilyRegistrationResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY REGISTRATION API ERROR ━━━━━━━━━━');
        debugPrint('METHOD: ${error.requestOptions.method}');
        debugPrint('STATUS CODE: ${error.response?.statusCode}');
        debugPrint('REQUEST URL: ${error.requestOptions.uri}');
        debugPrint('ERROR TYPE: ${error.type}');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');

        final data = error.response?.data;

        if (data is Map) {
          debugPrint('RESPONSE KEYS: ${data.keys.toList()}');
          debugPrint('MESSAGE: ${data['message']}');
          debugPrint('ERROR CODE: ${data['code']}');
          debugPrint('SUCCESS: ${data['success']}');
        } else {
          debugPrint('ERROR MESSAGE: ${error.message}');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    } catch (error) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY REGISTRATION ERROR ━━━━━━━━━━');
        debugPrint('ERROR TYPE: ${error.runtimeType}');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    }
  }
}
