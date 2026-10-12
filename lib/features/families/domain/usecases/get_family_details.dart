import '../entities/family_details_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyDetails {
  const GetFamilyDetails({required this._repository});

  final FamilyRepository _repository;

  Future<FamilyDetailsEntity> call(int id) {
    return _repository.getFamilyDetails(id);
  }
}
