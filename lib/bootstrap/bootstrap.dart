import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumen/core/utils/logger.dart';
import 'package:lumen/core/di/injection_container.dart' as di;

import '../core/constants/app_constants.dart';
import '../core/constants/enums.dart';
import '../features/notes/models/notes_model.dart';
import '../features/timer/models/timer_history_model.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await _initializeHive();

  // Initialize dependency injection
  await di.init();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.e('Flutter error', details.exception, details.stack);
  };

  // Add cross-flavor configuration here

  runApp(await builder());
}

/// Initialize Hive for local storage
Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteTypeAdapter());
    Hive.registerAdapter(NoteModelAdapter());
    Hive.registerAdapter(TimerHistoryModelAdapter());

    await Hive.openBox<NoteModel>(AppConstants.notesBox);
    await Hive.openBox<TimerHistoryModel>(AppConstants.timerHistoryBox);

    AppLogger.i('Hive initialized successfully');
  } catch (e, stack) {
    AppLogger.e('Failed to initialize Hive', e, stack);
    rethrow;
  }
}
