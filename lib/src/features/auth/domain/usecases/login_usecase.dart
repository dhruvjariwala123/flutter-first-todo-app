import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  AuthRepository authRepository;

  LoginUsecase(this.authRepository);
  Future<Either<Exception, void>> execute({
    required String email,
    required String password,
  }) {
    return authRepository.loginUser(email: email, password: password);
  }
}
