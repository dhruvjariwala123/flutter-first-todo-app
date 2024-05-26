import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:first_todo_app/src/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:first_todo_app/src/features/auth/data/model/user_model.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/local/todo_local_data_source.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final TodoLocalDataSource todoLocal;
  AuthRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.todoLocal});

  @override
  Future<Either<Exception, void>> logOutUser() async {
    remoteDataSource.logOutUser();
    final result = await localDataSource.removeUserInfo();
    return result.fold((left) => Left(left), (right) async {
      return todoLocal.deleteTodosData();
    });
  }

  @override
  Future<Either<Exception, void>> loginUser(
      {required String email, required String password}) {
    return remoteDataSource.loginUser(email: email, password: password);
  }

  @override
  Future<Either<Exception, void>> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    final result =
        await remoteDataSource.registerUser(email: email, password: password);
    return result.fold((left) async => Left(left), (right) async {
      if (right != null && right.additionalUserInfo!.isNewUser) {
        final user = right.user;
        if (user != null) {
          final UserModel userModel =
              UserModel(uid: user.uid, name: name, email: email);
          await remoteDataSource.storeUserDetailsOnDB(userModel: userModel);
          await localDataSource.storeUserInfo(userModel);
          return todoLocal.deleteTodosData();
        }
      }
      return Right(null);
    });
  }
}
