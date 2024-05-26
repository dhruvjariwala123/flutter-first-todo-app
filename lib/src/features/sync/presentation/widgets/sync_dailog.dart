import 'package:first_todo_app/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncDailog extends StatelessWidget {
  const SyncDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Sync Needed!\npress ok for navigate to Sync Data page"),
      actions: [
        TextButton(
          onPressed: () {
            print("ok pressed");

            Navigator.pushReplacementNamed(context, "/sync");
          },
          child: Text("ok"),
        ),
        TextButton(
          onPressed: () {
            print("cancle pressed");
            BlocProvider.of<HomeBloc>(context).add(GetTodosEvent());
          },
          child: Text("cancle"),
        ),
      ],
    );
  }
}
