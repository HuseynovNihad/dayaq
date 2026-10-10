import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../families/data/datasource/family_remote_data_source.dart';
import '../../families/data/repositories/family_repository_impl.dart';
import '../../families/domain/repositories/family_repository.dart';
import '../../families/domain/usecases/get_families.dart';
import '../presentation/bloc/home_bloc.dart';

void registerHomeDependencies(GetIt sl) {
  // DATA SOURCE
  sl.registerLazySingleton<FamilyRemoteDataSource>(
    () => FamilyRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // REPOSITORY
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(remoteDataSource: sl<FamilyRemoteDataSource>()),
  );

  // USE CASE
  sl.registerLazySingleton<GetFamilies>(
    () => GetFamilies(repository: sl<FamilyRepository>()),
  );

  // BLOC
  sl.registerFactory<HomeBloc>(() => HomeBloc(getFamilies: sl<GetFamilies>()));
}
