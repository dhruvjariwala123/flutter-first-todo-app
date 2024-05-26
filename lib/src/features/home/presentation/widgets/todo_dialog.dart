import 'package:first_todo_app/src/core/shared/widgets/my_text_field.dart';
import 'package:first_todo_app/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/priority_enum.dart';
import 'my_chip.dart';

class TodoDialog extends StatelessWidget {
  final String hintText;
  Function onOk;
  final TextEditingController taskController;
  TodoDialog({super.key, required this.hintText, required this.onOk})
      : taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prioritiesList = [Priority.low, Priority.medium, Priority.high];
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final List<bool> list;
        if (state is PrioritiesState) {
          list = state.priorities;
        } else {
          list = [true, false, false];
        }
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                controller: taskController,
                isSecure: false,
                text: hintText,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyChip(
                      label: "low",
                      onTap: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(PrioritySelectedEvent(index: 0));
                      },
                      color: list[0] ? Colors.purple : Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MyChip(
                      color: list[1] ? Colors.purple : Colors.grey,
                      label: "medium",
                      onTap: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(PrioritySelectedEvent(index: 1));
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MyChip(
                      color: list[2] ? Colors.purple : Colors.grey,
                      onTap: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(PrioritySelectedEvent(index: 2));
                      },
                      label: "high",
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  final String task = taskController.text;
                  final int index =
                      list.indexWhere((element) => element == true);
                  final Priority priority = prioritiesList[index];
                  onOk(priority: priority, task: task);

                  Navigator.of(context).pop();
                },
                child: const Text(
                  "ok",
                  style: TextStyle(fontSize: 16),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "cancle",
                  style: TextStyle(fontSize: 16),
                )),
          ],
        );
      },
    );
  }
}
