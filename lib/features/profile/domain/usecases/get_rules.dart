import '../entities/rule_entity.dart';
import '../repositories/profile_repository.dart';

class GetRules {
  const GetRules({required this._repository});

  final ProfileRepository _repository;

  Future<List<RuleEntity>> call() {
    return _repository.getRules();
  }
}
