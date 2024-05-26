import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class ChangeTodoCompleteStatusUsecase {
  final TodoRepository todoRepository;
  ChangeTodoCompleteStatusUsecase({required this.todoRepository});

  Future<Either<Exception, Todo>> execute({
    required Todo todo,
  }) {
    return todoRepository.changeTodoCompleteStatus(todo: todo);
  }
}
