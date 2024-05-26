part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props;
}

class RegisterationEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  RegisterationEvent(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword});

  @override
  // TODO: implement props
  List<Object> get props => [name, email, password];
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;
  LogInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
