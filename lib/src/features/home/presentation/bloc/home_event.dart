part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props;
}

class PrioritySelectedEvent extends HomeEvent {
  final int index;
  PrioritySelectedEvent({required this.index});
  @override
  List<Object> get props => [index];
}

class AddTodoEvent extends HomeEvent {
  final String task;
  final Priority priority;
  AddTodoEvent({required this.priority, required this.task});
  @override
  List<Object> get props => [task, priority];
}

class GetTodosEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ChangeTodoCompletedStatusEvent extends HomeEvent {
  final Todo todo;
  ChangeTodoCompletedStatusEvent({required this.todo});
  @override
  List<Object> get props => [todo];
}

class UpdateTodoEvent extends HomeEvent {
  final Todo oldTodo;
  final Todo newTodo;
  UpdateTodoEvent({required this.oldTodo, required this.newTodo});
  @override
  List<Object> get props => [oldTodo, newTodo];
}

class DeleteTodoEvent extends HomeEvent {
  final Todo todo;
  DeleteTodoEvent({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoCategoryChangeEvent extends HomeEvent {
  final TodoCategory todoCategory;
  TodoCategoryChangeEvent({required this.todoCategory});
  @override
  List<Object> get props => [todoCategory];
}

class CheckSyncTodoEvent extends HomeEvent {
  @override
  List<Object> get props => [];
}
