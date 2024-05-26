import 'package:dartz/dartz.dart';

import '../repositories/sync_todo_repository.dart';

class SyncTodoDataFromLocalToCloudUsecase {
  final SyncTodoRepository syncTodoRepo;
  SyncTodoDataFromLocalToCloudUsecase({required this.syncTodoRepo});
  Future<Either<Exception, void>> execute() {
    return syncTodoRepo.syncTodoDataFromLocalToCloud();
  }
}
