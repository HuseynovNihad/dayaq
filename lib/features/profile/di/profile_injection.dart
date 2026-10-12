import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/profile_remote_data_source.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_about.dart';
import '../domain/usecases/get_term_conditions.dart';
import '../domain/usecases/get_rules.dart';
import '../presentation/bloc/profile_content_bloc.dart';

void registerProfileDependencies(GetIt sl) {
  // DATA SOURCE
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // REPOSITORY
  sl.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );

  // USE CASES
  sl.registerLazySingleton<GetAbout>(
    () => GetAbout(repository: sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<GetTermConditions>(
    () => GetTermConditions(repository: sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<GetRules>(
    () => GetRules(repository: sl<ProfileRepository>()),
  );

  // BLOC
  sl.registerFactory<ProfileContentBloc>(
    () => ProfileContentBloc(
      getAbout: sl<GetAbout>(),
      getTermConditions: sl<GetTermConditions>(),
      getRules: sl<GetRules>(),
    ),
  );
}
