import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user_entity.dart';

class LogOutUsecase {
  AuthRepository authRepository;

  LogOutUsecase(this.authRepository);
  Future<Either<Exception, void>> execute() {
    return authRepository.logOutUser();
  }
}
