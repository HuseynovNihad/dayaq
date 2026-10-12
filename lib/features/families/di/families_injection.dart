import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasource/family_remote_data_source.dart';
import '../data/repositories/family_repository_impl.dart';
import '../domain/repositories/family_repository.dart';
import '../domain/usecases/get_families.dart';
import '../domain/usecases/get_family_details.dart';
import '../domain/usecases/register_family.dart';
import '../presentation/bloc/families_bloc.dart';
import '../presentation/details_bloc/family_details_bloc.dart';
import '../presentation/list_bloc/families_list_bloc.dart';

void registerFamiliesDependencies(GetIt sl) {
  // DATA SOURCE
  sl.registerLazySingleton<FamilyRemoteDataSource>(
    () => FamilyRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // REPOSITORY
  sl.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(remoteDataSource: sl<FamilyRemoteDataSource>()),
  );

  // USE CASES
  sl.registerLazySingleton<GetFamilies>(
    () => GetFamilies(repository: sl<FamilyRepository>()),
  );

  sl.registerLazySingleton<GetFamilyDetails>(
    () => GetFamilyDetails(repository: sl<FamilyRepository>()),
  );

  sl.registerLazySingleton<RegisterFamily>(
    () => RegisterFamily(repository: sl<FamilyRepository>()),
  );

  // REGISTRATION BLOC
  sl.registerFactory<FamiliesBloc>(
    () => FamiliesBloc(registerFamily: sl<RegisterFamily>()),
  );

  // FAMILIES LIST BLOC
  sl.registerFactory<FamiliesListBloc>(
    () => FamiliesListBloc(getFamilies: sl<GetFamilies>()),
  );

  // FAMILY DETAILS BLOC
  sl.registerFactory<FamilyDetailsBloc>(
    () => FamilyDetailsBloc(getFamilyDetails: sl<GetFamilyDetails>()),
  );
}
