import 'package:dartz/dartz.dart';

import '../../../../core/constants/priority_enum.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUsecase {
  final TodoRepository todoRepository;
  GetTodosUsecase({required this.todoRepository});

  Future<Either<Exception, List<Todo>>> execute() {
    return todoRepository.getTodos();
  }
}
