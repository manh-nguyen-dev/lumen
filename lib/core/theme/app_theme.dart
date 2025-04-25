import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({this.themeMode = ThemeMode.system});
  final ThemeMode themeMode;

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}

// Theme events
abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThemeModeChanged extends ThemeEvent {
  ThemeModeChanged(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

// Load saved theme event
class LoadThemeSettings extends ThemeEvent {}

// Theme BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<LoadThemeSettings>(_onLoadThemeSettings);
  }
  Future<void> _onLoadThemeSettings(
    LoadThemeSettings event,
    Emitter<ThemeState> emit,
  ) async {}
}

// Helper extension methods for theme
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void setThemeMode(ThemeMode themeMode) {
    BlocProvider.of<ThemeBloc>(this).add(ThemeModeChanged(themeMode));
  }
}
