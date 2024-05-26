part of 'sync_todo_bloc.dart';

sealed class SyncTodoState extends Equatable {
  const SyncTodoState();

  @override
  List<Object> get props;
}

final class SyncTodoInitial extends SyncTodoState {
  @override
  List<Object> get props => [];
}

abstract class SyncTodoActionState extends SyncTodoState {}

class WaitingForSyncTodoState extends SyncTodoState {
  @override
  List<Object> get props => [];
}

class SyncTodoDataSuccessState extends SyncTodoActionState {
  @override
  List<Object> get props => [];
}

class SyncTodoDataFailureState extends SyncTodoActionState {
  @override
  List<Object> get props => [];
}
