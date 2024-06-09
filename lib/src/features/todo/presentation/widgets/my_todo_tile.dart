import 'package:first_todo_app/src/features/home/presentation/widgets/my_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/constants/priority_enum.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/widgets/todo_dialog.dart';
import '../../domain/entities/todo_entity.dart';

class MyTodoTile extends StatelessWidget {
  Todo todo;
  MyTodoTile({super.key, required this.todo});
  void showUpdateTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TodoDialog(
        hintText: "Enter the new task",
        initialValue: todo.task,
        initialPriority: todo.priority,
        onOk: ({required Priority priority, required String task}) {
          final Todo newTodo = Todo(
              id: todo.id, task: task, isCompleted: false, priority: priority);
          BlocProvider.of<HomeBloc>(context)
              .add(UpdateTodoEvent(oldTodo: todo, newTodo: newTodo));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TodoCompletedStausChangeSuccessfulState) {
          if (todo.task == state.todo.task) {
            todo.isCompleted = state.todo.isCompleted;
          }
        }
        if (state is TodoUpdateSuccessfulState) {
          if (todo.id == state.todo.id) {
            todo = state.todo;
          }
        }
        if (state is TodoDeleteSuccessfulState) {
          BlocProvider.of<HomeBloc>(context).add(GetTodosEvent());
        }
        return Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  showUpdateTodoDialog(context);
                },
                borderRadius: BorderRadius.circular(5),
                backgroundColor: Colors.amber.shade500,
                icon: Icons.settings,
              ),
              SlidableAction(
                onPressed: (_) {
                  BlocProvider.of<HomeBloc>(context)
                      .add(DeleteTodoEvent(todo: todo));
                },
                borderRadius: BorderRadius.circular(5),
                backgroundColor: Colors.red.shade600,
                icon: Icons.delete,
              )
            ],
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    todo.task,
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                MyChip(
                  color: Colors.purple,
                  label: todo.priority.name,
                  onTap: () {},
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                    value: todo.isCompleted,
                    onChanged: (newValue) {
                      todo.isCompleted = newValue ?? false;
                      BlocProvider.of<HomeBloc>(context)
                          .add(ChangeTodoCompletedStatusEvent(todo: todo));
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
