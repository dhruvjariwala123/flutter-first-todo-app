part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props;
}

class ChangeThemEvent extends ThemeEvent {
  final bool isLight;
  ChangeThemEvent({required this.isLight});
  @override
  List<Object> get props => [isLight];
}
