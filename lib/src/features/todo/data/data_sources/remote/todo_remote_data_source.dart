import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_todo_app/src/core/exceptions/app_exceptions.dart';
import 'package:first_todo_app/src/features/todo/data/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constants/priority_enum.dart';
import '../../../domain/entities/todo_entity.dart';

class TodoRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  TodoRemoteDataSource(
      {required this.firebaseFirestore, required this.firebaseAuth});
  Future<Either<AppException, TodoModel>> addTodo(
      {required String task, required Priority priority}) async {
    try {
      // first fetch user data
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      var uuid = Uuid();
      final todo = TodoModel(
              id: uuid.v4(),
              task: task,
              isCompleted: false,
              priority: priority,
              isPresentOnCloud: true)
          .toJson();
      firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .add(todo);

      return Right(TodoModel.fromJson(todo));
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }

  Future<Either<AppException, TodoModel>> changeTodoCompleteStatus(
      {required TodoModel todo}) async {
    try {
      // first fetch user data
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      final todoResult = await firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .where("id", isEqualTo: todo.id)
          .get();

      if (todoResult.docs.isEmpty) {
        return Left(TodoNotFoundException("todo is not present"));
      }
      final todoId = todoResult.docs.first.id;
      firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .doc(todoId)
          .set(todo.toJson());
      return Right(todo);
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }

  Future<Either<AppException, List<TodoModel>>> getTodos() async {
    try {
      // first fetch user data
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      final todoResult = await firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .get();
      final data =
          todoResult.docs.map((e) => TodoModel.fromJson(e.data())).toList();

      return Right(data);
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }

  Future<Either<AppException, Todo>> updateTodo(
      {required TodoModel oldTodo, required TodoModel newTodo}) async {
    try {
      // first fetch user data
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      final todoResult = await firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .where("task", isEqualTo: oldTodo.task)
          .get();

      if (todoResult.docs.isEmpty) {
        return Left(TodoNotFoundException("todo is not present"));
      }
      final todoId = todoResult.docs.first.id;
      firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .doc(todoId)
          .set(newTodo.toJson());
      return Right(newTodo);
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserDataByUid(
      {required String uid}) {
    return firebaseFirestore
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();
  }

  Future<Either<AppException, void>> deleteTodo(
      {required TodoModel todo}) async {
    try {
      print("in deleteTodo");
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      print("${todo.id}");
      final todoResult = await firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .where("id", isEqualTo: todo.id)
          .get();
      if (todoResult.docs.isNotEmpty) {
        await firebaseFirestore
            .collection("users/${userData.docs.first.id}/todos")
            .doc("${todoResult.docs.first.id}")
            .delete();
      }
      return Right(null);
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }

  Future<Either<AppException, void>> setTodos(
      {required List<TodoModel> todos}) async {
    try {
      // first fetch user data
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(UnauthorizedUserException("user is not logged in"));
      }
      final userData = await getUserDataByUid(uid: user.uid);
      // if user is present so, add the to todos sub collection.
      if (userData.docs.isEmpty) {
        return Left(UserNotFoundException("user not found"));
      }
      final snapshot = await firebaseFirestore
          .collection("users/${userData.docs.first.id}/todos")
          .get();
      final batch = firebaseFirestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      for (final todo in todos) {
        final docRef = firebaseFirestore
            .collection("users/${userData.docs.first.id}/todos")
            .doc();
        batch.set(docRef, todo.toJson());
      }
      try {
        await batch.commit();
        return Right(null);
      } on Exception catch (e) {
        return Left(CloudDBException(e.toString()));
      }
    } on Exception catch (e) {
      return Left(CloudDBException(e.toString()));
    }
  }
}
