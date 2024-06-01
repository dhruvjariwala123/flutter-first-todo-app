part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props;
}

class LightThemeState extends ThemeState {
  @override
  List<Object> get props => [];
}

class DarkThemeState extends ThemeState {
  @override
  List<Object> get props => [];
}
