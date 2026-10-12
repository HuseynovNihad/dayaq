import '../entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
}
