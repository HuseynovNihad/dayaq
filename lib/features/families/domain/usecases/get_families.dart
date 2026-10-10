import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilies {
  const GetFamilies({required this._repository});

  final FamilyRepository _repository;

  Future<List<FamilyEntity>> call() {
    return _repository.getFamilies();
  }
}
