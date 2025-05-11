import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../../features/habit/models/habit_model.dart';
import '../../features/habit/repositories/habit_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  await _registerHiveAdapters();

  // Register repositories
  final habitBox = Hive.box<HabitModel>(AppConstants.habitsBox);
  sl.registerLazySingleton<HabitRepository>(() => HabitRepository(habitBox));
}

// Register all Hive adapters
Future<void> _registerHiveAdapters() async {
  try {
    if (kDebugMode) {
      print('Hive adapters registered successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error registering Hive adapters: $e');
    }
  }
}
