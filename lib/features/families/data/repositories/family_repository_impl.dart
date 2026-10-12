import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';

import '../../domain/entities/family_details_entity.dart';
import '../../domain/entities/family_entity.dart';
import '../../domain/entities/family_registration_response_entity.dart';
import '../../domain/repositories/family_repository.dart';

import '../datasource/family_remote_data_source.dart';
import '../models/family_registration_request_model.dart';

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

  @override
  Future<FamilyDetailsEntity> getFamilyDetails(int id) async {
    try {
      return await _remoteDataSource.getFamilyDetails(id);
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure(
        'Ailənin ətraflı məlumatları düzgün formatda deyil.',
      );
    }
  }

  @override
  Future<FamilyRegistrationResponseEntity> registerFamily(
    FamilyRegistrationRequestModel request,
  ) async {
    try {
      return await _remoteDataSource.registerFamily(request);
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure(
        'Ailə qeydiyyatının cavabı düzgün formatda deyil.',
      );
    }
  }
}
