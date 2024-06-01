import 'package:first_todo_app/src/core/uitls/show_normal_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/widgets/my_text_field.dart';
import '../../../sync/presentation/bloc/bloc/sync_todo_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 600 ? true : false;
    double? TextFieldMaxSize = isDesktop ? 550 : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyTextFormField(
                text: "Enter Email",
                isSecure: false,
                controller: emailController,
                maxWidth: TextFieldMaxSize,
              ),
              SizedBox(
                height: 20,
              ),
              MyTextFormField(
                text: "Enter Password",
                isSecure: true,
                controller: passwordController,
                maxWidth: TextFieldMaxSize,
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    BlocProvider.of<SyncTodoBloc>(context)
                        .add(SyncTodoDataFromCloudToLocalEvent());
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => route.isFirst);
                  }
                  if (state is LoginFailureState) {
                    showNormalSnackBar(
                        context: context,
                        content: Text('Login is Faild'),
                        backColor: Colors.red);
                  }
                },
                builder: (context, state) {
                  Widget buttonChild;
                  if (state is LoadingState) {
                    buttonChild = Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    buttonChild = Center(child: Text("Login"));
                  }
                  return ElevatedButton(
                      onPressed: () {
                        final String email = emailController.text;
                        final String password = passwordController.text;
                        BlocProvider.of<AuthBloc>(context)
                            .add(LogInEvent(email: email, password: password));
                      },
                      child: SizedBox(width: 100, child: buttonChild));
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/registeration");
                  },
                  child: Text("or Register?"))
            ],
          ),
        ),
      ),
    );
  }
}
