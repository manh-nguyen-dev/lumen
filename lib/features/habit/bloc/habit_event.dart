import 'package:equatable/equatable.dart';
import '../models/habit_model.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {}

class AddHabit extends HabitEvent {
  final HabitModel habit;

  const AddHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class UpdateHabit extends HabitEvent {
  final HabitModel habit;

  const UpdateHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final HabitModel habit;

  const DeleteHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class CompleteHabit extends HabitEvent {
  final HabitModel habit;

  const CompleteHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class UndoCompleteHabit extends HabitEvent {
  final HabitModel habit;

  const UndoCompleteHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}
