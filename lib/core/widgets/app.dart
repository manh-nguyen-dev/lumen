import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive/hive.dart';
import 'package:lumen/core/constants/app_constants.dart';

import '../../features/habit/bloc/habit_bloc.dart';
import '../../features/habit/models/habit_model.dart';
import '../../features/habit/repositories/habit_repository.dart';
import '../theme/app_theme.dart';
import '../theme/themes/dark_theme.dart';
import '../theme/themes/light_theme.dart';
import '../../config/routes/app_router.dart';

/// Main application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = defaultTransitionRoute();

    return MultiBlocProvider(
      providers: [
        // Global BLoC providers
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(LoadThemeSettings()),
        ),
        BlocProvider<HabitBloc>(
          create:
              (_) => HabitBloc(
                HabitRepository(Hive.box<HabitModel>(AppConstants.habitsBox)),
              ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: AppConstants.appName,
            theme: getLightTheme(),
            darkTheme: getDarkTheme(),
            themeMode: themeState.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [FlutterQuillLocalizations.delegate],
          );
        },
      ),
    );
  }
}
