import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class AddTodoUsecase {
  final TodoRepository todoRepository;
  AddTodoUsecase({required this.todoRepository});

  Future<Either<Exception, Todo>> execute({
    required String task,
    required Priority priority,
  }) {
    return todoRepository.addTodo(task: task, priority: priority);
  }
}
