import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<AppException, Todo>> addTodo(
      {required String task, required Priority priority});
  Future<Either<AppException, Todo>> updateTodo(
      {required Todo oldTodo, required Todo newTodo});
  Future<Either<AppException, void>> deleteTodo({required Todo todo});
  Future<Either<AppException, Todo>> changeTodoCompleteStatus(
      {required Todo todo});
  Future<Either<AppException, List<Todo>>> getTodos();
}
