import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class Logout {
  const Logout({required this._repository});

  final AuthRepository _repository;

  Future<Result<void>> call() {
    return _repository.logout();
  }
}
