import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUsecase {
  final TodoRepository todoRepository;
  UpdateTodoUsecase({required this.todoRepository});

  Future<Either<Exception, Todo>> execute({
    required Todo oldTodo,
    required Todo newTodo,
  }) {
    return todoRepository.updateTodo(oldTodo: oldTodo, newTodo: newTodo);
  }
}
