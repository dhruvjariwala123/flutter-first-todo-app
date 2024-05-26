import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/auth/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharePref;
  AuthLocalDataSource({required this.sharePref});
  Future<Either<Exception, void>> storeUserInfo(UserModel userModel) async {
    try {
      final isStored =
          await sharePref.setString("userData", jsonEncode(userModel.toJson()));
      if (isStored) {
        return Right(null);
      }
      return Left(Exception("can't save user data on device local storage"));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> removeUserInfo() async {
    try {
      await sharePref.remove("userData");
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
