import 'package:flutter_bloc/flutter_bloc.dart';

import 'habit_event.dart';
import 'habit_state.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository habitRepository;

  HabitBloc(this.habitRepository) : super(HabitInitial()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<CompleteHabit>(_onCompleteHabit);
    on<UndoCompleteHabit>(_onUndoCompleteHabit);
  }

  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(HabitLoading());
    try {
      final habits = await habitRepository.getAllHabits();
      emit(HabitLoaded(habits));
    } catch (e) {
      emit(HabitError('Failed to load habits'));
    }
  }

  Future<void> _onAddHabit(AddHabit event, Emitter<HabitState> emit) async {
    if (state is HabitLoaded) {
      final updatedHabits = List<HabitModel>.from((state as HabitLoaded).habits)
        ..add(event.habit);
      await habitRepository.saveHabit(event.habit);
      emit(HabitLoaded(updatedHabits));
    }
  }

  Future<void> _onUpdateHabit(
    UpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    if (state is HabitLoaded) {
      final updatedHabits =
          (state as HabitLoaded).habits.map((h) {
            return h.id == event.habit.id ? event.habit : h;
          }).toList();
      await habitRepository.saveHabit(event.habit);
      emit(HabitLoaded(updatedHabits));
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    if (state is HabitLoaded) {
      final updatedHabits =
          (state as HabitLoaded).habits
              .where((h) => h.id != event.habit.id)
              .toList();
      await habitRepository.deleteHabit(event.habit);
      emit(HabitLoaded(updatedHabits));
    }
  }

  Future<void> _onCompleteHabit(
      CompleteHabit event,
      Emitter<HabitState> emit,
      ) async {
    if (state is HabitLoaded) {
      final updatedHabits = (state as HabitLoaded).habits.map((h) {
        if (h.id == event.habit.id) {
          h.completedDates.add(DateTime.now().toIso8601String().split('T').first);
        }
        return h;
      }).toList();

      await habitRepository.saveHabit(event.habit);
      emit(HabitLoaded(updatedHabits));
    }
  }

  Future<void> _onUndoCompleteHabit(
      UndoCompleteHabit event,
      Emitter<HabitState> emit,
      ) async {
    if (state is HabitLoaded) {
      final updatedHabits = (state as HabitLoaded).habits.map((h) {
        if (h.id == event.habit.id) {
          h.completedDates.remove(DateTime.now().toIso8601String().split('T').first);
        }
        return h;
      }).toList();

      await habitRepository.saveHabit(event.habit);
      emit(HabitLoaded(updatedHabits));
    }
  }
}
