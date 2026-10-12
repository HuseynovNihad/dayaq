import '../../domain/entities/term_condition_entity.dart';

class TermConditionModel extends TermConditionEntity {
  const TermConditionModel({required super.termCondition});

  factory TermConditionModel.fromJson(Map<String, dynamic> json) {
    return TermConditionModel(
      termCondition: json['term_condition']?.toString() ?? '',
    );
  }
}
