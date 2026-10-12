import 'package:equatable/equatable.dart';

class TermConditionEntity extends Equatable {
  const TermConditionEntity({required this.termCondition});

  final String termCondition;

  @override
  List<Object?> get props => [termCondition];
}
