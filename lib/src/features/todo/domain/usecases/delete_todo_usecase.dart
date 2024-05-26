import 'package:dartz/dartz.dart';

import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUsecase {
  final TodoRepository todoRepository;
  DeleteTodoUsecase({required this.todoRepository});

  Future<Either<Exception, void>> execute({
    required Todo todo,
  }) {
    return todoRepository.deleteTodo(todo: todo);
  }
}
