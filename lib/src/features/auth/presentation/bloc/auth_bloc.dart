import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/registration_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  RegistrationUsecase registrationUsecase;
  LoginUsecase loginUsecase;
  LogOutUsecase logOutUsecase;

  AuthBloc({
    required this.registrationUsecase,
    required this.loginUsecase,
    required this.logOutUsecase,
  }) : super(AuthInitial()) {
    on<RegisterationEvent>(
        (RegisterationEvent event, Emitter<AuthState> emit) async {
      final name = event.name.trim();
      final email = event.email.trim();
      final password = event.password.trim();
      final confirmPassword = event.confirmPassword.trim();

      if (confirmPassword != password) {
        emit(ConfirmPasswordAndPasswordNotMatch());
      } else {
        emit(LoadingState());
        Either result = await registrationUsecase.execute(
            email: email, password: password, name: name);

        result.fold((left) {
          print("left : $left");
          emit(RegisterationFailureState());
        }, (right) {
          print("right : $right");
          emit(RegisterationSuccessState());
        });
      }
    });
    on<LogInEvent>((LogInEvent event, Emitter<AuthState> emit) async {
      emit(LoadingState());
      final email = event.email.trim();
      final password = event.password.trim();
      Either result = await loginUsecase.execute(
        email: email,
        password: password,
      );
      result.fold((left) => emit(LoginFailureState()),
          (right) => emit(LoginSuccessState()));
    });
    on<LogOutEvent>((LogOutEvent event, Emitter<AuthState> emit) async {
      emit(LoadingState());
      Either result = await logOutUsecase.execute();
      result.fold((left) => emit(LogOutFailureState()),
          (right) => emit(LogOutSuccessState()));
    });
  }
}
