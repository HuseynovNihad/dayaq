import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl({required this._dio});

  final Dio _dio;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get<dynamic>(ApiEndpoints.notifications);

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Bildiriş cavabı düzgün formatda deyil.');
    }

    final data = responseData['data'];

    if (data is! List) {
      throw const FormatException('Bildiriş siyahısı düzgün formatda deyil.');
    }

    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'Bildiriş məlumatı düzgün formatda deyil.',
            );
          }

          return NotificationModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
