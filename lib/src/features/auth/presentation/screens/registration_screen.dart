import 'package:first_todo_app/src/core/uitls/show_normal_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/widgets/my_text_field.dart';
import '../bloc/auth_bloc.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isDesktop = MediaQuery.of(context).size.width > 600 ? true : false;
    double? TextFieldMaxSize = isDesktop ? 550 : null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) => current is AuthActionState,
          listener: (context, state) {
            if (state is RegisterationSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/", (route) => route.isFirst);
            }
            if (state is RegisterationFailureState) {
              showNormalSnackBar(
                  context: context,
                  content: Text("Registration was Failed"),
                  backColor: Colors.red);
            }
            if (state is ConfirmPasswordAndPasswordNotMatch) {
              showNormalSnackBar(
                  context: context,
                  content: Text(
                    "Password and confirm password not Match!",
                    style: TextStyle(color: Colors.black),
                  ),
                  backColor: Colors.amber);
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
              buttonChild = Center(child: Text("Register"));
            }

            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyTextFormField(
                      text: "Enter User Name",
                      isSecure: false,
                      controller: userNameController,
                      maxWidth: TextFieldMaxSize,
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    MyTextFormField(
                      text: "Enter Confirm Password",
                      isSecure: true,
                      controller: confirmPasswordController,
                      maxWidth: TextFieldMaxSize,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final String name = userNameController.text;
                          final String password = passwordController.text;
                          final String email = emailController.text;
                          final String confirmPassword =
                              confirmPasswordController.text;

                          BlocProvider.of<AuthBloc>(context).add(
                            RegisterationEvent(
                              name: name,
                              email: email,
                              password: password,
                              confirmPassword: confirmPassword,
                            ),
                          );
                        },
                        child: SizedBox(width: 100, child: buttonChild)),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text("or have alreday registerd , Login?"))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
