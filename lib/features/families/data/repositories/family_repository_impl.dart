import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../domain/entities/family_entity.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasource/family_remote_data_source.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  const FamilyRepositoryImpl({required this._remoteDataSource});

  final FamilyRemoteDataSource _remoteDataSource;

  @override
  Future<List<FamilyEntity>> getFamilies() async {
    try {
      return await _remoteDataSource.getFamilies();
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure('Ailələrin məlumatları düzgün formatda deyil.');
    }
  }
}
