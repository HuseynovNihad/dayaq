import '../../data/models/family_registration_request_model.dart';
import '../entities/family_registration_response_entity.dart';
import '../repositories/family_repository.dart';

class RegisterFamily {
  const RegisterFamily({required this._repository});

  final FamilyRepository _repository;

  Future<FamilyRegistrationResponseEntity> call(
    FamilyRegistrationRequestModel request,
  ) async {
    return _repository.registerFamily(request);
  }
}
