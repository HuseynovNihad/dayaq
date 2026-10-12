part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => false;
}

final class NotificationsStarted extends NotificationEvent {
  const NotificationsStarted();
}

final class NotificationsRefreshed extends NotificationEvent {
  const NotificationsRefreshed();
}
