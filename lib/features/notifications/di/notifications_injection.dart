import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasource/notification_remote_data_source.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/usecases/get_notifications.dart';
import '../presentation/bloc/notification_bloc.dart';

void registerNotificationsDependencies(GetIt sl) {
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetNotifications>(
    () => GetNotifications(repository: sl<NotificationRepository>()),
  );

  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(getNotifications: sl<GetNotifications>()),
  );
}
