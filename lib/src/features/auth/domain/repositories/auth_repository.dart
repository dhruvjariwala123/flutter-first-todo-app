import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Exception, void>> loginUser({
    required String email,
    required String password,
  });
  Future<Either<Exception, void>> registerUser({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Exception, void>> logOutUser();
}
