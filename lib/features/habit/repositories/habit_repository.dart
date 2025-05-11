import 'package:hive/hive.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final Box<HabitModel> _habitBox;

  HabitRepository(this._habitBox);

  Future<List<HabitModel>> getAllHabits() async {
    return _habitBox.values.toList();
  }

  Future<void> saveHabit(HabitModel habit) async {
    await _habitBox.put(habit.id, habit);
  }

  Future<void> deleteHabit(HabitModel habit) async {
    await _habitBox.delete(habit.id);
  }

  HabitModel? getHabitById(String id) {
    return _habitBox.get(id);
  }
}
