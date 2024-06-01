import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightThemeState()) {
    on<ChangeThemEvent>((event, emit) {
      if (event.isLight) {
        emit(LightThemeState());
      } else {
        emit(DarkThemeState());
      }
    });
  }
}
