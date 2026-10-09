import '../../../../core/error/result.dart';
import '../entities/login_response_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase({
    required AuthRepository repository,
  }) : _repository = repository;

  final AuthRepository _repository;

  Future<Result<LoginResponseEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(
      email: email,
      password: password,
    );
  }
}