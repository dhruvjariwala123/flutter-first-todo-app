import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<Exception, Todo>> addTodo(
      {required String task, required Priority priority});
  Future<Either<Exception, Todo>> updateTodo(
      {required Todo oldTodo, required Todo newTodo});
  Future<Either<Exception, void>> deleteTodo({required Todo todo});
  Future<Either<Exception, Todo>> changeTodoCompleteStatus(
      {required Todo todo});
  Future<Either<Exception, List<Todo>>> getTodos();
}
