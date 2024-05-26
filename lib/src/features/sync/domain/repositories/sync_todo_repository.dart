import 'package:dartz/dartz.dart';

abstract class SyncTodoRepository {
  Future<Either<Exception, bool>> isSyncNeeded();
  Future<Either<Exception, void>> syncTodoDataFromLocalToCloud();
  Future<Either<Exception, void>> syncTodoDataFromCloudToLocal();
}
