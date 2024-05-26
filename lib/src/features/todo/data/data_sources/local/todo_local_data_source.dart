import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constants/priority_enum.dart';
import '../../models/todo_model.dart';

class TodoLocalDataSource {
  final SharedPreferences sharedPref;

  TodoLocalDataSource({required this.sharedPref});

  Future<Either<Exception, TodoModel>> addTodo(
      {required String task,
      required Priority priority,
      required String? uid,
      required bool isPresentOnCloud}) async {
    try {
      final result = await getTodos();
      final List<TodoModel> todoList = result.fold((left) {
        return [];
      }, (right) {
        return right;
      });
      final todo = TodoModel(
          task: task,
          isCompleted: false,
          priority: priority,
          id: uid ?? Uuid().v4(),
          isPresentOnCloud: isPresentOnCloud);
      todoList.add(todo);
      await sharedPref.setString("todoData", jsonEncode(todoList));
      return Right(todo);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> deleteTodo({required TodoModel todo}) async {
    try {
      final result = await getTodos();
      final List<TodoModel> todoList = result.fold((left) {
        return [];
      }, (right) {
        return right;
      });
      final index = todoList.indexWhere((element) => element.id == todo.id);
      if (index != -1) {
        todoList.removeAt(index);
      }
      final isSaved =
          await sharedPref.setString("todoData", jsonEncode(todoList));
      if (isSaved) {
        return Right(null);
      }
      return Left(Exception("can't save data in device local storage"));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, TodoModel>> updateTodo(
      {required TodoModel oldTodo, required TodoModel newTodo}) async {
    try {
      final result = await getTodos();
      final List<TodoModel> todoList = result.fold((left) {
        return [];
      }, (right) {
        return right;
      });
      final index = todoList.indexWhere((element) => element.id == oldTodo.id);
      if (index != -1) {
        todoList.removeAt(index);
      }
      todoList.add(newTodo);
      final isSaved =
          await sharedPref.setString("todoData", jsonEncode(todoList));
      if (isSaved) {
        return Right(newTodo);
      }
      return Left(Exception("can't update the data to device storage"));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, TodoModel>> changeTodoCompleteStatus(
      {required TodoModel todo}) async {
    try {
      final result = await getTodos();
      final List<TodoModel> todoList = result.fold((left) {
        return [];
      }, (right) {
        return right;
      });

      final index = todoList.indexWhere((element) => element.id == todo.id);
      if (index != -1) {
        todoList.removeAt(index);
      }
      todoList.add(todo);
      final isSaved =
          await sharedPref.setString("todoData", jsonEncode(todoList));
      if (isSaved) {
        return Right(todo);
      }
      return Left(Exception("can't change the data on device storage"));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, List<TodoModel>>> getTodos() async {
    try {
      final todoData = sharedPref.getString("todoData");
      final List<TodoModel> todoList;
      if (todoData == null) {
        todoList = [];
      } else {
        final todos = jsonDecode(todoData) as List<dynamic>;
        todoList = todos
            .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return Right(todoList);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> setTodos(
      {required List<TodoModel> todos}) async {
    try {
      sharedPref.setString("todoData", jsonEncode(todos));
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, void>> deleteTodosData() async {
    try {
      sharedPref.remove("todoData");
      return Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
