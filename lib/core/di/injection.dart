import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_injection.dart';
import '../../features/campaigns/di/campaigns_injection.dart';
import '../../features/donations/di/donations_injection.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/profile/di/profile_injection.dart';

import '../config/app_config.dart';
import '../network/dio_factory.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance;

void configureDependencies({AppConfig? config}) {
  _registerCoreDependencies(config);

  // Feature Dependencies
  registerAuthDependencies(sl);
  registerHomeDependencies(sl);
  registerCampaignsDependencies(sl);
  registerDonationsDependencies(sl);
  registerProfileDependencies(sl);
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
