import '../../domain/entities/about_entity.dart';

class AboutModel extends AboutEntity {
  const AboutModel({required super.about});

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(about: json['about']?.toString() ?? '');
  }
}
