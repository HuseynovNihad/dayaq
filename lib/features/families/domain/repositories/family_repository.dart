import '../../data/models/family_registration_request_model.dart';
import '../entities/family_details_entity.dart';
import '../entities/family_entity.dart';
import '../entities/family_registration_response_entity.dart';

abstract interface class FamilyRepository {
  Future<List<FamilyEntity>> getFamilies();

  Future<FamilyDetailsEntity> getFamilyDetails(int id);

  Future<FamilyRegistrationResponseEntity> registerFamily(
    FamilyRegistrationRequestModel request,
  );
}
