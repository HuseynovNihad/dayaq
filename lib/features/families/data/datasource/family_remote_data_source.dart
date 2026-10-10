import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/family_model.dart';

abstract interface class FamilyRemoteDataSource {
  Future<List<FamilyModel>> getFamilies();
}

class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  FamilyRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FamilyModel>> getFamilies() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.families);

    final responseData = response.data;

    if (kDebugMode) {
      debugPrint('========== FAMILY API ==========');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE TYPE: ${responseData.runtimeType}');
    }

    // Backend response:
    // {
    //   "data": [...]
    // }

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

      try {
        families.add(FamilyModel.fromJson(item));
      } catch (error) {
        if (kDebugMode) {
          debugPrint(
            'FAMILY PARSING FAILED: index=$index, '
            'errorType=${error.runtimeType}',
          );
        }

        rethrow;
      }
    }

    if (kDebugMode) {
      debugPrint('TOTAL FAMILIES: ${families.length}');
      debugPrint('========== FAMILY API SUCCESS ==========');
    }

    return families;
  }
}
