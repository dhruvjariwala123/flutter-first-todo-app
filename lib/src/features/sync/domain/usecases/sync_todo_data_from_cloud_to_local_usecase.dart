import 'package:dartz/dartz.dart';

import '../repositories/sync_todo_repository.dart';

class SyncTodoDataFromCloudToLocalUsecase {
  final SyncTodoRepository syncTodoRepo;
  SyncTodoDataFromCloudToLocalUsecase({required this.syncTodoRepo});
  Future<Either<Exception, void>> execute() {
    return syncTodoRepo.syncTodoDataFromCloudToLocal();
  }
}
