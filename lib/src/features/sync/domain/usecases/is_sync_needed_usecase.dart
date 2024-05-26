import 'package:dartz/dartz.dart';

import '../repositories/sync_todo_repository.dart';

class IsSyncNeededUsecase {
  final SyncTodoRepository syncTodoRepo;
  IsSyncNeededUsecase({required this.syncTodoRepo});
  Future<Either<Exception, bool>> execute() {
    return syncTodoRepo.isSyncNeeded();
  }
}
