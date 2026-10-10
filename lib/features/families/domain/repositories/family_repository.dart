import '../entities/family_entity.dart';

abstract interface class FamilyRepository {
  Future<List<FamilyEntity>> getFamilies();
}
