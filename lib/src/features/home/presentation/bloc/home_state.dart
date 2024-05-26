part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props;
}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class WaitingForAddTodoState extends HomeState {
  @override
  List<Object> get props => [];
}

class TodoAddSuccessfulState extends HomeActionState {
  @override
  List<Object> get props => [];
}

class TodoAddFailureState extends HomeActionState {
  @override
  List<Object> get props => [];
}

class PrioritiesState extends HomeState {
  final List<bool> priorities;
  const PrioritiesState({required this.priorities});
  @override
  // TODO: implement props
  List<Object> get props => [priorities];
}

class WaitingForTodosDataFetchingState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TodosLoaddedSuccessfulState extends HomeState {
  final List<Todo> todos;
  const TodosLoaddedSuccessfulState({required this.todos});
  @override
  // TODO: implement props
  List<Object> get props => [todos];
}

class TodosLoaddedFailureState extends HomeState {
  final String error;
  const TodosLoaddedFailureState({required this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class WaitingForChangeTodoCompletedStatusState extends HomeState {
  @override
  List<Object> get props => [];
}

class TodoCompletedStausChangeSuccessfulState extends HomeState {
  final Todo todo;
  const TodoCompletedStausChangeSuccessfulState({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoCompletedStausChangeFailureState extends HomeState {
  @override
  List<Object> get props => [];
}

class WaitingForTodoUpdateState extends HomeState {
  @override
  List<Object> get props => [];
}

class TodoUpdateSuccessfulState extends HomeState {
  final Todo todo;
  const TodoUpdateSuccessfulState({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoUpdateFailureState extends HomeState {
  @override
  List<Object> get props => [];
}

class WaitingForTodoDeleteState extends HomeState {
  @override
  List<Object> get props => [];
}

class TodoDeleteSuccessfulState extends HomeState {
  final Todo todo;
  const TodoDeleteSuccessfulState({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoDeleteFailureState extends HomeState {
  @override
  List<Object> get props => [];
}

class WaitingForSyncNeededState extends HomeState {
  @override
  List<Object> get props => [];
}

class SyncNeededState extends HomeState {
  @override
  List<Object> get props => [];
}

class SyncNotNeededState extends HomeState {
  @override
  List<Object> get props => [];
}
