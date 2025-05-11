import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object?> get props => [];
}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<HabitModel> habits;

  const HabitLoaded(this.habits);

  @override
  List<Object?> get props => [habits];
}

class HabitError extends HabitState {
  final String message;

  const HabitError(this.message);

  @override
  List<Object?> get props => [message];
}
