import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../network/dio_factory.dart';

final sl = GetIt.instance;

void configureDependencies({AppConfig? config}) {
  sl.registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment());
  sl.registerLazySingleton<Dio>(
    () => createDio(sl<AppConfig>()),
    dispose: (dio) => dio.close(force: true),
  );
  // Register datasources, repository interfaces, use cases, then Bloc factories here.
  // Route-scoped Blocs belong to BlocProvider, which closes them on disposal.
}
