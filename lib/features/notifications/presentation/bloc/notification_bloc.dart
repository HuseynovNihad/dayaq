import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required this._getNotifications})
    : super(const NotificationInitial()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsRefreshed>(_onRefreshed);
  }

  final GetNotifications _getNotifications;

  bool _isLoading = false;

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationState> emit,
  ) async {
    if (_isLoading) return;

    await _loadNotifications(emit, refresh: false);
  }

  Future<void> _onRefreshed(
    NotificationsRefreshed event,
    Emitter<NotificationState> emit,
  ) async {
    if (_isLoading) return;

    await _loadNotifications(emit, refresh: true);
  }

  Future<void> _loadNotifications(
    Emitter<NotificationState> emit, {
    required bool refresh,
  }) async {
    _isLoading = true;

    final previousState = state;

    if (refresh && previousState is NotificationLoaded) {
      emit(previousState.copyWith(isRefreshing: true));
    } else {
      emit(const NotificationLoading());
    }

    try {
      final notifications = await _getNotifications();

      if (emit.isDone) return;

      emit(NotificationLoaded(notifications: notifications));
    } on AppFailure catch (error) {
      if (emit.isDone) return;

      if (refresh && previousState is NotificationLoaded) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(NotificationError(message: error.message));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      if (emit.isDone) return;

      if (refresh && previousState is NotificationLoaded) {
        emit(previousState.copyWith(isRefreshing: false));
      } else {
        emit(
          const NotificationError(
            message: 'Bildirişləri yükləmək mümkün olmadı.',
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }
}
