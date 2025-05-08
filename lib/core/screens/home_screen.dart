import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/habit/screens/habit_screen.dart';
import '../../features/notes/screens/notes_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/timer/screens/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const NotesScreen(),
    const TimerScreen(),
    HabitScreen(),
    const CalendarScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            label: '',
            icon: Icon(LucideIcons.stickyNote),
            selectedIcon: Icon(Icons.note),
          ),
          NavigationDestination(
            label: '',
            icon: Icon(LucideIcons.timer),
            selectedIcon: Icon(Icons.timer),
          ),
          NavigationDestination(
            label: '',
            icon: Icon(LucideIcons.layoutList),
            selectedIcon: Icon(LucideIcons.layoutList),
          ),
          NavigationDestination(
            label: '',
            icon: Icon(LucideIcons.calendar),
            selectedIcon: Icon(LucideIcons.calendarRange),
          ),
          NavigationDestination(
            label: '',
            icon: Icon(LucideIcons.settings),
            selectedIcon: Icon(LucideIcons.settings),
          ),
        ],
      ),
    );
  }
}
