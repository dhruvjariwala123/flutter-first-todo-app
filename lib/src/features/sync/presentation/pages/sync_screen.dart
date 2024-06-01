import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/sync_todo_bloc.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync Data"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: BlocConsumer<SyncTodoBloc, SyncTodoState>(
        listener: (context, state) {
          if (state is SyncTodoDataFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Can't Sync",
              ),
              backgroundColor: Colors.red,
            ));
          }
          if (state is SyncTodoDataSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Data Synced Successfully",
              ),
              backgroundColor: Colors.green,
            ));
          }
        },
        buildWhen: (previous, current) {
          return current is WaitingForSyncTodoState ||
              current is SyncTodoDataSuccessState ||
              current is SyncTodoDataFailureState;
        },
        builder: (context, state) {
          if (state is WaitingForSyncTodoState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sync data from Local Storage to Cloud",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SyncTodoBloc>(context)
                        .add(SyncTodoDataFromLocalToCloudEvent());
                  },
                  child: Text("Sync"),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Sync data from Cloud to Local Storage",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SyncTodoBloc>(context)
                        .add(SyncTodoDataFromCloudToLocalEvent());
                  },
                  child: Text("Sync"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
