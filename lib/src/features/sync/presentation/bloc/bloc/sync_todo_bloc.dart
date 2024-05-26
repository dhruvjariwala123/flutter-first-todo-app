import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:first_todo_app/src/features/sync/domain/usecases/sync_todo_data_from_cloud_to_local_usecase.dart';
import 'package:first_todo_app/src/features/sync/domain/usecases/sync_todo_data_from_local_to_cloud_usecase.dart';

part 'sync_todo_event.dart';
part 'sync_todo_state.dart';

class SyncTodoBloc extends Bloc<SyncTodoEvent, SyncTodoState> {
  final SyncTodoDataFromCloudToLocalUsecase syncTodoDataFromCloudToLocalUsecase;
  final SyncTodoDataFromLocalToCloudUsecase syncTodoDataFromLocalToCloudUsecase;

  SyncTodoBloc(
      {required this.syncTodoDataFromCloudToLocalUsecase,
      required this.syncTodoDataFromLocalToCloudUsecase})
      : super(SyncTodoInitial()) {
    on<SyncTodoDataFromCloudToLocalEvent>((event, emit) async {
      emit(WaitingForSyncTodoState());
      final result = await syncTodoDataFromCloudToLocalUsecase.execute();
      result.fold((left) => emit(SyncTodoDataFailureState()),
          (right) => emit(SyncTodoDataSuccessState()));
    });
    on<SyncTodoDataFromLocalToCloudEvent>((event, emit) async {
      emit(WaitingForSyncTodoState());
      final result = await syncTodoDataFromLocalToCloudUsecase.execute();
      result.fold((left) => emit(SyncTodoDataFailureState()),
          (right) => emit(SyncTodoDataSuccessState()));
    });
  }
}
