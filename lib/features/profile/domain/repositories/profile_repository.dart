import '../entities/about_entity.dart';
import '../entities/term_condition_entity.dart';
import '../entities/rule_entity.dart';

abstract interface class ProfileRepository {
  Future<List<AboutEntity>> getAbout();

  Future<List<TermConditionEntity>> getTermConditions();

  Future<List<RuleEntity>> getRules();
}
