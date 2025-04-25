import 'package:go_router/go_router.dart';
import 'package:lumen/config/routes/routes.dart';
import 'package:lumen/core/screens/home_screen.dart';
import 'package:lumen/core/screens/not_found_screen.dart';

import '../../core/screens/premium_screen.dart';
import '../../core/screens/theme_customization_screen.dart';
import '../../features/notes/models/notes_model.dart';
import '../../features/notes/screens/note_detail_screen.dart';

/// App router configuration
GoRouter defaultTransitionRoute() {
  return GoRouter(
    initialLocation: Routes.home,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => PremiumScreen(),
      ),
      GoRoute(
        path: Routes.themeCustomization,
        builder: (context, state) => ThemeCustomizationScreen(),
      ),
      GoRoute(
        path: Routes.noteDetail,
        builder: (context, state) {
          final note = state.extra as NoteModel;
          return NoteDetailScreen(note: note);
        },
      ),
    ],
  );
}
