import '../../../../core/error/result.dart';
import '../entities/login_response_entity.dart';

abstract interface class AuthRepository {
  Future<Result<LoginResponseEntity>> login({
    required String email,
    required String password,
  });
}
