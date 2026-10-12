import '../../domain/entities/family_registration_response_entity.dart';

class FamilyRegistrationResponseModel extends FamilyRegistrationResponseEntity {
  const FamilyRegistrationResponseModel({required super.message});

  factory FamilyRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];

    if (message is! String) {
      throw const FormatException(
        'Family registration response must contain a string message.',
      );
    }

    return FamilyRegistrationResponseModel(message: message);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
