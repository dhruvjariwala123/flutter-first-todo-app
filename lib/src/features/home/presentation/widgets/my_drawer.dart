import 'package:first_todo_app/src/core/uitls/show_normal_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade800,
                      size: 100,
                    )),
              )
            ],
          )),
          ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/sync");
              },
              title: Text("Sync Data"),
              leading: Icon(Icons.sync)),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LogOutSuccessState) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  "/login",
                  (route) {
                    print("route : ${route.isFirst}");
                    return false;
                  },
                );
              }
              if (state is LogOutFailureState) {
                showNormalSnackBar(
                    context: context,
                    content: Text("Log out failed"),
                    backColor: Colors.red);
              }
              // TODO: implement listener
            },
            builder: (context, state) => ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "Whould you like to Log out!",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(LogOutEvent());
                                Navigator.pop(context);
                              },
                              child: Text(
                                "ok",
                                style: TextStyle(fontSize: 16),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "cancle",
                                style: TextStyle(fontSize: 16),
                              ))
                        ],
                      );
                    });
              },
              title: Text("Log Out"),
              leading: Icon(Icons.logout_outlined),
            ),
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isLightTheme = state is LightThemeState ? true : false;
              return ListTile(
                title: Text("Theme"),
                trailing: Switch(
                  onChanged: (value) {
                    BlocProvider.of<ThemeBloc>(context)
                        .add(ChangeThemEvent(isLight: value));
                  },
                  value: isLightTheme,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
