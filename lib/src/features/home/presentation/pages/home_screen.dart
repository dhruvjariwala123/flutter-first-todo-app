import 'dart:async';

import 'package:first_todo_app/src/core/network_service.dart';
import 'package:first_todo_app/src/features/todo/domain/entities/todo_category.dart';

import 'package:first_todo_app/src/features/todo/presentation/widgets/my_todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/priority_enum.dart';
import '../../../../core/service_locator.dart';
import '../../../sync/presentation/widgets/sync_dailog.dart';
import '../../../todo/domain/entities/todo_entity.dart';
import '../../../todo/presentation/widgets/category_chip.dart';
import '../bloc/home_bloc.dart';
import '../widgets/my_drawer.dart';
import '../widgets/todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? internetStream;
  void showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TodoDialog(
        hintText: "Enter the task",
        onOk: ({required String task, required Priority priority}) {
          BlocProvider.of<HomeBloc>(context)
              .add(AddTodoEvent(priority: priority, task: task));
        },
      ),
    );
  }

  void showSyncNeededDailog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
      child: Text("sync"),
    )));
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<HomeBloc>(context).add(GetTodosEvent());
    BlocProvider.of<HomeBloc>(context).add(CheckSyncTodoEvent());
    internetStream = ServiceManager.sl<NetworkService>()
        .connectivity
        .onConnectivityChanged
        .listen((event) {
      BlocProvider.of<HomeBloc>(context).add(CheckSyncTodoEvent());
    });
  }

  @override
  void dispose() {
    if (internetStream != null) {
      internetStream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("home"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showAddTodoDialog(context);
              },
            )
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: BlocProvider.of<HomeBloc>(context),
          listener: (context, state) {
            // TODO: implement listener
          },
          buildWhen: (previous, current) =>
              current is TodosLoaddedSuccessfulState ||
              current is WaitingForTodosDataFetchingState ||
              current is SyncNeededState,
          builder: (context, state) {
            List<Todo> list = [];

            if (state is WaitingForTodosDataFetchingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SyncNeededState) {
              print("sync neede");
              return Builder(
                  builder: (context) => Container(
                        width: 400,
                        height: 200,
                        child: SyncDailog(),
                      ));
            }
            if (state is TodosLoaddedSuccessfulState) {
              print(state.todos.toString());
              list = state.todos;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 30,
                      decoration: BoxDecoration(),
                      child: CategoryChip(
                        onChanged: (String? value) {
                          if (value != null) {
                            print(
                                "category : ${TodoCategoryExtention.getTodoCategoryFromName(name: value)}");
                            BlocProvider.of<HomeBloc>(context).add(
                                TodoCategoryChangeEvent(
                                    todoCategory: TodoCategoryExtention
                                        .getTodoCategoryFromName(name: value)));
                          }
                        },
                      )),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return MyTodoTile(
                          todo: list[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
