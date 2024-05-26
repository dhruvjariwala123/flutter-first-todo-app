import 'package:dartz/dartz.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/local/todo_local_data_source.dart';

import '../../../../core/network_service.dart';
import '../../../todo/data/data_sources/remote/todo_remote_data_source.dart';
import '../../../todo/data/models/todo_model.dart';
import '../../domain/repositories/sync_todo_repository.dart';

class SyncTodoRepositoryImpl implements SyncTodoRepository {
  final TodoRemoteDataSource todoRemote;
  final TodoLocalDataSource todoLocal;
  final NetworkService networkService;
  SyncTodoRepositoryImpl(
      {required this.todoRemote,
      required this.todoLocal,
      required this.networkService});

  @override
  Future<Either<Exception, bool>> isSyncNeeded() async {
    print("isSyncNeed Call");
    final bool hasInternet = await networkService.hasInternetConnection();
    if (!hasInternet) {
      return Right(false);
    }
    List<TodoModel> cloudTodos = [];
    List<TodoModel> localTodos = [];
    final cloudResult = await todoRemote.getTodos();
    final localResult = await todoLocal.getTodos();
    cloudResult.fold((left) {
      cloudTodos = [];
    }, (right) {
      cloudTodos = right;
    });
    localResult.fold((left) {
      localTodos = [];
    }, (right) {
      localTodos = right;
    });
    if (cloudTodos.isEmpty && localTodos.isEmpty) {
      return Right(false);
    }
    if (cloudTodos.isEmpty && localTodos.isNotEmpty) {
      return Right(true);
    }
    if (localTodos.isEmpty && cloudTodos.isNotEmpty) {
      return Right(true);
    }
    if (localTodos.length != cloudTodos.length) {
      return Right(true);
    }
    for (int i = 0; i < cloudTodos.length; i++) {
      bool isSame = false;
      for (int j = 0; j < localTodos.length; j++) {
        if (cloudTodos[i] == localTodos[j]) {
          isSame = true;
        }
      }
      if (!isSame) {
        return Right(true);
      }
    }
    return Right(false);
  }

  @override
  Future<Either<Exception, void>> syncTodoDataFromCloudToLocal() async {
    try {
      if (await networkService.hasInternetConnection()) {
        final cloudResult = await todoRemote.getTodos();
        return cloudResult.fold((left) {
          return Left(left);
        }, (cloudTodos) {
          for (final todo in cloudTodos) {
            todo.isPresentOnCloud = true;
          }
          return todoLocal.setTodos(todos: cloudTodos);
        });
      }
      return Left(Exception("don't have internet"));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> syncTodoDataFromLocalToCloud() async {
    try {
      if (await networkService.hasInternetConnection()) {
        final localResult = await todoLocal.getTodos();
        return localResult.fold((left) {
          return Left(left);
        }, (localTodos) async {
          for (final todo in localTodos) {
            todo.isPresentOnCloud = true;
          }
          final finalResult = await todoRemote.setTodos(todos: localTodos);

          return finalResult.fold((l) => Left(l), (r) {
            return todoLocal.setTodos(todos: localTodos);
          });
        });
      }
      return Left(Exception("don't have internet"));
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
