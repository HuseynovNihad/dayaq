import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_injection.dart';
import '../../features/campaigns/di/campaigns_injection.dart';
import '../../features/donations/di/donations_injection.dart';
import '../../features/home/di/home_injection.dart';
import '../../features/profile/di/profile_injection.dart';
import '../config/app_config.dart';
import '../network/dio_factory.dart';

final sl = GetIt.instance;

void configureDependencies({AppConfig? config}) {
  _registerCoreDependencies(config);

  registerAuthDependencies(sl);
  registerHomeDependencies(sl);
  registerCampaignsDependencies(sl);
  registerDonationsDependencies(sl);
  registerProfileDependencies(sl);
}

void _registerCoreDependencies(AppConfig? config) {
  sl.registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment());

  sl.registerLazySingleton<Dio>(
    () => createDio(sl<AppConfig>()),
    dispose: (dio) => dio.close(force: true),
  );
}
