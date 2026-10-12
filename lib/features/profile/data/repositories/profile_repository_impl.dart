import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/network/dio_failure_mapper.dart';

import '../../domain/entities/about_entity.dart';
import '../../domain/entities/term_condition_entity.dart';
import '../../domain/entities/rule_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this._remoteDataSource});

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<List<AboutEntity>> getAbout() async {
    try {
      return await _remoteDataSource.getAbout();
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure('Haqqımızda məlumatları düzgün formatda deyil.');
    }
  }

  @override
  Future<List<TermConditionEntity>> getTermConditions() async {
    try {
      return await _remoteDataSource.getTermConditions();
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure('Şərtlər və qaydalar düzgün formatda deyil.');
    }
  }

  @override
  Future<List<RuleEntity>> getRules() async {
    try {
      return await _remoteDataSource.getRules();
    } on DioException catch (error) {
      throw mapDioFailure(error);
    } on FormatException {
      throw const AppFailure('İstifadə qaydaları düzgün formatda deyil.');
    }
  }
}
