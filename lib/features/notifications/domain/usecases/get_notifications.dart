import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  const GetNotifications({required this._repository});

  final NotificationRepository _repository;

  Future<List<NotificationEntity>> call() {
    return _repository.getNotifications();
  }
}
