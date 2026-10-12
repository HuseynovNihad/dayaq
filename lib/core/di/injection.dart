import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_injection.dart';
import '../../features/families/di/families_injection.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/notifications/di/notifications_injection.dart';
import '../../features/profile/di/profile_injection.dart';

import '../config/app_config.dart';
import '../network/dio_factory.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance;

void configureDependencies({AppConfig? config}) {
  _registerCoreDependencies(config);

  // Feature Dependencies
  registerAuthDependencies(sl);
  registerFamiliesDependencies(sl);
  registerHomeDependencies(sl);
  registerProfileDependencies(sl);
  registerNotificationsDependencies(sl);
}

void _registerCoreDependencies(AppConfig? config) {
  // App Configuration
  sl.registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment());

  // Flutter Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Token Storage
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(secureStorage: sl<FlutterSecureStorage>()),
  );

  // Dio HTTP Client
  sl.registerLazySingleton<Dio>(
    () => createDio(sl<AppConfig>(), tokenStorage: sl<TokenStorage>()),
    dispose: (dio) => dio.close(force: true),
  );
}
