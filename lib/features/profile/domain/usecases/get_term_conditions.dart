import '../entities/term_condition_entity.dart';
import '../repositories/profile_repository.dart';

class GetTermConditions {
  const GetTermConditions({required this._repository});

  final ProfileRepository _repository;

  Future<List<TermConditionEntity>> call() {
    return _repository.getTermConditions();
  }
}
