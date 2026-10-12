import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/about_model.dart';
import '../models/term_condition_model.dart';
import '../models/rule_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<AboutModel>> getAbout();
  Future<List<TermConditionModel>> getTermConditions();
  Future<List<RuleModel>> getRules();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<List<AboutModel>> getAbout() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.about);
    final data = _extractList(response.data, 'about');

    return data.map(AboutModel.fromJson).toList(growable: false);
  }

  @override
  Future<List<TermConditionModel>> getTermConditions() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.termCondition);
    final data = _extractList(response.data, 'term_condition');

    return data.map(TermConditionModel.fromJson).toList(growable: false);
  }

  @override
  Future<List<RuleModel>> getRules() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.rule);
    final data = _extractList(response.data, 'rule');

    return data.map(RuleModel.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _extractList(
    dynamic responseData,
    String expectedField,
  ) {
    dynamic data = responseData;

    if (data is Map) {
      final wrapper = Map<String, dynamic>.from(data);

      if (wrapper.containsKey('data')) {
        data = wrapper['data'];
      } else if (wrapper.containsKey(expectedField)) {
        data = [wrapper];
      } else {
        throw const FormatException('Invalid profile response structure.');
      }
    }

    if (data is Map) {
      data = [data];
    }

    if (data is! List) {
      throw const FormatException(
        'Profile response must contain a JSON array.',
      );
    }

    final result = <Map<String, dynamic>>[];

    for (var index = 0; index < data.length; index++) {
      final item = data[index];

      if (item is! Map) {
        throw FormatException('Invalid profile data at index $index.');
      }

      final json = Map<String, dynamic>.from(item);

      if (!json.containsKey(expectedField)) {
        throw FormatException(
          'Missing required profile field: $expectedField.',
        );
      }

      result.add(json);
    }

    return result;
  }
}
