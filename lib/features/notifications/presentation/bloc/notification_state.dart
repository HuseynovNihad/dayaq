part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => false;
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

final class NotificationLoaded extends NotificationState {
  const NotificationLoaded({
    required this.notifications,
    this.isRefreshing = false,
  });

  final List<NotificationEntity> notifications;
  final bool isRefreshing;

  bool get isEmpty => notifications.isEmpty;

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? isRefreshing,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [notifications, isRefreshing];
}

final class NotificationError extends NotificationState {
  const NotificationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
