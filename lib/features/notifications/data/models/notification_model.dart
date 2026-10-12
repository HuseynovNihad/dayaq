import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];

    final id = switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    if (id == null) {
      throw const FormatException('Notification ID düzgün formatda deyil.');
    }

    return NotificationModel(
      id: id,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
