part of 'sync_todo_bloc.dart';

sealed class SyncTodoEvent extends Equatable {
  const SyncTodoEvent();

  @override
  List<Object> get props;
}

class SyncTodoDataFromLocalToCloudEvent extends SyncTodoEvent {
  @override
  List<Object> get props => [];
}

class SyncTodoDataFromCloudToLocalEvent extends SyncTodoEvent {
  @override
  List<Object> get props => [];
}
