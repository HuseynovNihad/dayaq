import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({required this._remoteDataSource});

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      return await _remoteDataSource.getNotifications();
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure(
        'Bildiriş məlumatları düzgün formatda deyil.',
        kind: FailureKind.server,
      );
    }
  }
}
