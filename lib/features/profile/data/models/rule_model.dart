import '../../domain/entities/rule_entity.dart';

class RuleModel extends RuleEntity {
  const RuleModel({required super.rule, super.video});

  factory RuleModel.fromJson(Map<String, dynamic> json) {
    final video = json['video']?.toString().trim();

    return RuleModel(
      rule: json['rule']?.toString() ?? '',
      video: video == null || video.isEmpty ? null : video,
    );
  }
}
