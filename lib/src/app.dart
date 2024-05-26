import 'package:first_todo_app/src/core/service_locator.dart';
import 'package:first_todo_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:first_todo_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:first_todo_app/src/features/auth/presentation/screens/registration_screen.dart';
import 'package:first_todo_app/src/features/sync/presentation/bloc/bloc/sync_todo_bloc.dart';
import 'package:first_todo_app/src/features/sync/presentation/pages/sync_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final sl = ServiceManager.sl;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => sl<HomeBloc>(),
        ),
        BlocProvider<SyncTodoBloc>(
          create: (context) => sl<SyncTodoBloc>(),
        ),
      ],
      child: MaterialApp(
        routes: {
          "/": (context) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
          "/registeration": (context) => RegistrationScreen(),
          "/login": (context) => LoginScreen(),
          "/sync": (context) => SyncScreen(),
        },
        initialRoute: "/",
        title: 'Flutter Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
