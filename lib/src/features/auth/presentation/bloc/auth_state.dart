part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props;
}

abstract class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {
  @override
  // TODO:implement props
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginSuccessState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class LoginFailureState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class RegisterationSuccessState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class RegisterationFailureState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class LogOutSuccessState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class LogOutFailureState extends AuthActionState {
  @override
  List<Object> get props => [];
}

class ConfirmPasswordAndPasswordNotMatch extends AuthActionState {
  @override
  List<Object> get props => [];
}
