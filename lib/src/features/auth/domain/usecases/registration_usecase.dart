import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user_entity.dart';

class RegistrationUsecase {
  AuthRepository authRepository;

  RegistrationUsecase(this.authRepository);
  Future<Either<Exception, void>> execute({
    required String email,
    required String password,
    required String name,
  }) {
    return authRepository.registerUser(
        email: email, password: password, name: name);
  }
}
