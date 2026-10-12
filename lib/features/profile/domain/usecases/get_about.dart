import '../entities/about_entity.dart';
import '../repositories/profile_repository.dart';

class GetAbout {
  const GetAbout({required this._repository});

  final ProfileRepository _repository;

  Future<List<AboutEntity>> call() {
    return _repository.getAbout();
  }
}
