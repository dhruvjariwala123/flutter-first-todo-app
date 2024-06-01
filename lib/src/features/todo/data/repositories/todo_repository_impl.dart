import 'package:dartz/dartz.dart';

import 'package:first_todo_app/src/core/constants/priority_enum.dart';
import 'package:first_todo_app/src/core/network_service.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/local/todo_local_data_source.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:first_todo_app/src/features/todo/data/models/todo_model.dart';

import 'package:first_todo_app/src/features/todo/domain/entities/todo_entity.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoRepositoryImlp implements TodoRepository {
  final TodoRemoteDataSource todoRemote;
  final TodoLocalDataSource todoLocal;
  final NetworkService networkService;
  TodoRepositoryImlp(
      {required this.todoRemote,
      required this.todoLocal,
      required this.networkService});
  @override
  Future<Either<AppException, Todo>> addTodo(
      {required String task, required Priority priority}) async {
    String? uid = null;
    bool isRemoteSuccess = false;
    if (await networkService.hasInternetConnection()) {
      final result = await todoRemote.addTodo(task: task, priority: priority);

      isRemoteSuccess = result.fold((left) {
        return false;
      }, (right) {
        uid = right.id;
        return true;
      });
    }
    return todoLocal.addTodo(
        task: task,
        priority: priority,
        uid: uid,
        isPresentOnCloud: isRemoteSuccess);
  }

  @override
  Future<Either<AppException, Todo>> changeTodoCompleteStatus(
      {required Todo todo}) async {
    bool isRemoteSuccess = false;
    if (await networkService.hasInternetConnection()) {
      final result = await todoRemote.changeTodoCompleteStatus(
          todo: TodoModel.fromEntity(todo, true));
      isRemoteSuccess = result.fold((left) {
        return false;
      }, (right) {
        return true;
      });
    }
    return todoLocal.changeTodoCompleteStatus(
        todo: TodoModel.fromEntity(todo, isRemoteSuccess));
  }

  @override
  Future<Either<AppException, void>> deleteTodo({required Todo todo}) async {
    bool isRemoteSuccess = false;
    if (await networkService.hasInternetConnection()) {
      final result =
          await todoRemote.deleteTodo(todo: TodoModel.fromEntity(todo, true));
      isRemoteSuccess = result.fold((left) {
        return false;
      }, (right) {
        return true;
      });
    }
    return todoLocal.deleteTodo(
      todo: TodoModel.fromEntity(todo, isRemoteSuccess),
    );
  }

  @override
  Future<Either<AppException, List<Todo>>> getTodos() async {
    if (await networkService.hasInternetConnection()) {
      return todoRemote.getTodos();
    }
    return todoLocal.getTodos();
  }

  @override
  Future<Either<AppException, Todo>> updateTodo(
      {required Todo oldTodo, required Todo newTodo}) async {
    bool isRemoteSuccess = false;

    final tempOld = oldTodo as TodoModel;
    if (await networkService.hasInternetConnection()) {
      final result = await todoRemote.updateTodo(
          oldTodo: TodoModel.fromEntity(oldTodo, tempOld.isPresentOnCloud),
          newTodo: TodoModel.fromEntity(newTodo, true));
      isRemoteSuccess = result.fold((left) {
        return false;
      }, (right) {
        return true;
      });
    }
    return todoLocal.updateTodo(
        oldTodo: TodoModel.fromEntity(oldTodo, tempOld.isPresentOnCloud),
        newTodo: TodoModel.fromEntity(newTodo, isRemoteSuccess));
  }
}
