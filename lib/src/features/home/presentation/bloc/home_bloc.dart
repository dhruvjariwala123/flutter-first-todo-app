import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/change_todo_complete_status_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/update_todo_usecase.dart';

import '../../../../core/constants/priority_enum.dart';
import '../../../sync/domain/usecases/is_sync_needed_usecase.dart';
import '../../../todo/domain/entities/todo_category.dart';
import '../../../todo/domain/entities/todo_entity.dart';
import '../../../todo/domain/usecases/get_todos_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddTodoUsecase addTodoUsecase;
  final GetTodosUsecase getTodosUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  final ChangeTodoCompleteStatusUsecase changeTodoCompleteStatusUsecase;
  final UpdateTodoUsecase updateTodoUsecase;
  final IsSyncNeededUsecase isSyncNeededUseCase;
  HomeBloc({
    required this.addTodoUsecase,
    required this.changeTodoCompleteStatusUsecase,
    required this.deleteTodoUsecase,
    required this.getTodosUsecase,
    required this.updateTodoUsecase,
    required this.isSyncNeededUseCase,
  }) : super(HomeInitial()) {
    on<PrioritySelectedEvent>((event, emit) {
      final List<bool> list = [false, false, false];
      list[event.index] = true;
      emit(PrioritiesState(priorities: list));
    });
    on<AddTodoEvent>((event, emit) async {
      emit(WaitingForAddTodoState());
      final result = await addTodoUsecase.execute(
          task: event.task, priority: event.priority);
      result.fold((Left) {
        print("left");
        emit(TodoAddFailureState());
      }, (right) {
        print("right");
        emit(TodoAddSuccessfulState());
        add(GetTodosEvent());
      });
    });
    on<GetTodosEvent>(
      (event, emit) async {
        emit(WaitingForTodosDataFetchingState());
        final result = await getTodosUsecase.execute();
        result.fold((Left) {
          TodosLoaddedFailureState(error: left.toString());
        }, (right) {
          emit(TodosLoaddedSuccessfulState(todos: right));
        });
      },
    );
    on<ChangeTodoCompletedStatusEvent>(
      (event, emit) async {
        emit(WaitingForChangeTodoCompletedStatusState());
        final result =
            await changeTodoCompleteStatusUsecase.execute(todo: event.todo);
        result.fold(
            (left) => null,
            (right) =>
                emit(TodoCompletedStausChangeSuccessfulState(todo: right)));
      },
    );
    on<UpdateTodoEvent>(
      (event, emit) async {
        emit(WaitingForTodoUpdateState());
        event.newTodo.isCompleted = event.oldTodo.isCompleted;
        final result = await updateTodoUsecase.execute(
            oldTodo: event.oldTodo, newTodo: event.newTodo);
        result.fold((left) => null,
            (right) => emit(TodoUpdateSuccessfulState(todo: right)));
      },
    );
    on<DeleteTodoEvent>(
      (event, emit) async {
        emit(WaitingForTodoDeleteState());
        final result = await deleteTodoUsecase.execute(todo: event.todo);
        result.fold((left) => emit(TodoDeleteFailureState()), (right) {
          emit(TodoDeleteSuccessfulState(todo: event.todo));
        });
      },
    );
    on<FilterTodosEvent>(
      (event, emit) async {
        List<Todo> data;
        final result = await getTodosUsecase.execute();
        List<Todo> todos = [];
        result.fold(
            (left) => emit(TodosLoaddedFailureState(error: left.toString())),
            (right) {
          todos = right;
        });

        if (event.todoCategory == TodoCategory.Completed) {
          data = todos.where((element) => element.isCompleted == true).toList();
        } else if (event.todoCategory == TodoCategory.UnCompleted) {
          data =
              todos.where((element) => element.isCompleted == false).toList();
        } else if (event.todoCategory == TodoCategory.All) {
          data = todos;
        } else {
          data = [];
        }
        if (event.todoPriority != "All") {
          data = data
              .where((element) => element.priority.name == event.todoPriority)
              .toList();
        }
        emit(TodosLoaddedSuccessfulState(todos: data));
      },
    );
    on<CheckSyncTodoEvent>((event, emit) async {
      emit(WaitingForSyncNeededState());
      final result = await isSyncNeededUseCase.execute();
      result.fold((Left) => emit(SyncNotNeededState()), (isNeeded) {
        if (isNeeded) {
          emit(SyncNeededState());
        } else {
          ("isNeeded : false");
          emit(SyncNotNeededState());
          add(GetTodosEvent());
        }
      });
    });
  }
}
