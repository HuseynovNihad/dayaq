import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        debugPrint('FAMILY DETAILS INVALID ID: $id');
      }
      throw const FormatException('Invalid family registration ID.');
    }

    final endpoint = ApiEndpoints.familyDetails(id);
    final stopwatch = Stopwatch()..start();

    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ FAMILY DETAILS REQUEST ━━━━━━━━━━');
      debugPrint('FAMILY ID: $id');
      debugPrint('METHOD: GET');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('BASE URL: ${_dio.options.baseUrl}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    try {
      final response = await _dio.get<dynamic>(endpoint);
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY DETAILS RESPONSE ━━━━━━━━━━');
        debugPrint('FAMILY ID: $id');
        debugPrint('REQUEST URL: ${response.requestOptions.uri}');
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('RESPONSE TYPE: ${response.data.runtimeType}');

        final data = response.data;

        if (data is Map) {
          debugPrint('RESPONSE KEYS: ${data.keys.toList()}');
          debugPrint('BACKEND MESSAGE: ${data['message']}');
          debugPrint('DATA TYPE: ${data['data'].runtimeType}');
        } else if (data is List) {
          debugPrint('ARRAY LENGTH: ${data.length}');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

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

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY DETAILS PARSING ━━━━━━━━━━');
        debugPrint('JSON KEYS: ${detailsJson.keys.toList()}');
        debugPrint('REGION TYPE: ${detailsJson['region'].runtimeType}');
        debugPrint('MEMBERS TYPE: ${detailsJson['members'].runtimeType}');
        debugPrint('DOCUMENTS TYPE: ${detailsJson['documents'].runtimeType}');
        debugPrint('NOTES TYPE: ${detailsJson['notes'].runtimeType}');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      final model = FamilyDetailsModel.fromJson(detailsJson);

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY DETAILS SUCCESS ━━━━━━━━━━');
        debugPrint('FAMILY ID: $id');
        debugPrint('MEMBERS COUNT: ${model.members.length}');
        debugPrint('DOCUMENTS COUNT: ${model.documents.length}');
        debugPrint('NOTES COUNT: ${model.notes.length}');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      return model;
    } on DioException catch (error) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY DETAILS API ERROR ━━━━━━━━━━');
        debugPrint('FAMILY ID: $id');
        debugPrint('METHOD: ${error.requestOptions.method}');
        debugPrint('REQUEST URL: ${error.requestOptions.uri}');
        debugPrint('STATUS CODE: ${error.response?.statusCode}');
        debugPrint('ERROR TYPE: ${error.type}');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('RESPONSE TYPE: ${error.response?.data.runtimeType}');

        final data = error.response?.data;

        if (data is Map) {
          debugPrint('RESPONSE KEYS: ${data.keys.toList()}');
          debugPrint('BACKEND MESSAGE: ${data['message']}');
          debugPrint('ERROR CODE: ${data['code']}');
          debugPrint('SUCCESS: ${data['success']}');
        } else if (data is String) {
          debugPrint('RESPONSE LENGTH: ${data.length}');
        }

        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    } catch (error) {
      stopwatch.stop();

      if (kDebugMode) {
        debugPrint('━━━━━━━━━━ FAMILY DETAILS PARSE ERROR ━━━━━━━━━━');
        debugPrint('FAMILY ID: $id');
        debugPrint('ERROR TYPE: ${error.runtimeType}');
        debugPrint('ERROR: $error');
        debugPrint('DURATION: ${stopwatch.elapsedMilliseconds} ms');
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      rethrow;
    }
  }

  @override
  Future<FamilyRegistrationResponseModel> registerFamily(
    FamilyRegistrationRequestModel request,
  ) async {
    final formData = await request.toFormData();

    final response = await _dio.post<dynamic>(
      ApiEndpoints.registerFamily,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'Family registration response must be a JSON object.',
      );
    }

    return FamilyRegistrationResponseModel.fromJson(responseData);
  }
}
