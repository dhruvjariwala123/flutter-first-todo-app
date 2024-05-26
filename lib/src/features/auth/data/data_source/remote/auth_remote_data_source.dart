import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/user_model.dart';

class AuthRemoteDataSource {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSource(
      {required this.firebaseAuth, required this.firebaseFirestore});
  Future<Either<Exception, void>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, UserCredential>> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> logOutUser() async {
    try {
      await firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> storeUserDetailsOnDB(
      {required UserModel userModel}) async {
    try {
      await firebaseFirestore.collection("users").add(userModel.toJson());
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }
}
