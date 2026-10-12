import 'package:equatable/equatable.dart';

class RuleEntity extends Equatable {
  const RuleEntity({required this.rule, this.video});

  final String rule;
  final String? video;

  @override
  List<Object?> get props => [rule, video];
}
